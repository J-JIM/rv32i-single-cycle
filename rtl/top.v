`default_nettype none
module top(input clk, reset);
    /* 해당 모듈은 high layer로
        단순 데이터 라인을 이용한 32bit CPU다.

        사용 모듈 : (ALU) alu, alu_control
                  (Memory) ismem, dmem, signextend
                  (Register) registerfile, programcounter
                  (control) control
    */

    // ─── PC → 명령어 가져오기 ────────────────────────────────
    wire [31:0] cnt;       // programcounter.pc  →  ismem.addr
    wire [31:0] inst;      // ismem.inst         →  아래 전부의 원천

    // ─── control 출력 7개 ────────────────────────────────────
    wire        branch;    // →  (beq 미구현 — 아직 꽂을 곳 없음)
    wire        MemRead;   // →  dmem.MemRead
    wire        MemWrite;  // →  dmem.MemWrite
    wire        MemtoReg;  // →  mux2 선택선
    wire        AluSrc;    // →  mux1 선택선
    wire        RegWrite;  // →  registerfile.RegWrite
    wire [1:0]  Aluop;     // →  alu_control.Aluop        ⚠ 2비트

    // ─── alu_control 출력 ────────────────────────────────────
    wire [1:0]  op;        // →  alu.op         ⚠ Aluop 과 다른 선이다

    // ─── registerfile 읽기 출력 (번호가 아니라 '값') ─────────
    wire [31:0] rdata1;    // regfile.s1  →  alu.a
    wire [31:0] rdata2;    // regfile.s2  →  mux1 입력 · dmem.wdata  (2곳)

    // ─── signextend 출력 ─────────────────────────────────────
    wire [31:0] imm;       // signextend.s  →  mux1 입력

    // ─── mux 2개 — 모듈이 없다. assign 삼항으로 만들 것 ──────
    wire [31:0] alu_b;     // mux1 출력  →  alu.b        (AluSrc  로 고름)
    wire [31:0] wb;        // mux2 출력  →  regfile.d    (MemtoReg 로 고름)

    // ─── ALU 출력 ────────────────────────────────────────────
    wire [31:0] alu_s;     // alu.s     →  dmem.addr · mux2 입력  (2곳)
    wire        zero;      // alu.zero  →  (beq 미구현)

    // ─── dmem 출력 ───────────────────────────────────────────
    wire [31:0] memdata;   // dmem.rdata  →  mux2 입력

    /* 선을 따로 안 만드는 것들 — inst 슬라이스를 인스턴스에 직접 적는다
         control.opcode      ← inst[6:0]
         registerfile.ra1    ← inst[19:15]
         registerfile.ra2    ← inst[24:20]
         registerfile.id     ← inst[11:7]
         signextend.data     ← inst[31:20]
         alu_control.func3   ← inst[14:12]
         alu_control.func7   ← inst[30]      ⚠ 1비트다
    */

    // ─── 인스턴스 ───────────────────────────────────────────

    // 1. PC — 다음 명령어 주소. pc+4 는 이 모듈 안에 내장돼 있다.
    programcounter pc0(
        .clk    (clk),
        .reset  (reset),
        .pc     (cnt)
    );

    // 2. 명령어 메모리 — cnt 번지의 명령어를 꺼낸다 (sw/program.hex)
    ismem instmem(
        .addr   (cnt),
        .inst   (inst)
    );

    // 3. 제어 유닛 — opcode 7비트만 보고 제어선 7개를 세운다
    control ctrl(
        .opcode   (inst[6:0]),
        .branch   (branch),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .AluSrc   (AluSrc),
        .MemtoReg (MemtoReg),
        .RegWrite (RegWrite),
        .Aluop    (Aluop)
    );

    // 4. 레지스터 파일 — rs1·rs2 를 읽고, 쓰기는 RegWrite 가 허가할 때만
    registerfile regfile(
        .d        (wb),            // 써 넣을 값 (mux2 출력)
        .id       (inst[11:7]),    // 쓸 레지스터 번호 rd
        .ra1      (inst[19:15]),   // 읽을 번호 rs1
        .ra2      (inst[24:20]),   // 읽을 번호 rs2
        .clk      (clk),
        .RegWrite (RegWrite),
        .s1       (rdata1),
        .s2       (rdata2)
    );

    // 5. 부호 확장 — I-type 12비트 상수를 32비트로
    signextend sext(
        .data   (inst[31:20]),
        .s      (imm)
    );

    // 6. ALU 제어 — Aluop(2) + funct 를 합쳐 실제 연산 코드를 만든다
    alu_control alc(
        .func7  (inst[30]),        // 1비트다
        .Aluop  (Aluop),
        .func3  (inst[14:12]),
        .op     (op)
    );

    // 7. mux1 — ALU 두 번째 입력: 레지스터 값이냐 상수냐
    assign alu_b = AluSrc ? imm : rdata2;

    // 8. ALU
    alu alu0(
        .a      (rdata1),
        .b      (alu_b),
        .op     (op),
        .s      (alu_s),
        .zero   (zero)
    );

    // 9. 데이터 메모리 — 주소는 ALU 결과, 쓸 값은 rs2
    dmem datamem(
        .addr     (alu_s),
        .wdata    (rdata2),
        .MemRead  (MemRead),
        .MemWrite (MemWrite),
        .clk      (clk),
        .rdata    (memdata)
    );

    // 10. mux2 — 레지스터에 써 넣을 값: 메모리에서 읽은 것이냐 ALU 결과냐
    assign wb = MemtoReg ? memdata : alu_s;

    /*
    // 11. immgen - opcode 별 R, I, S, U, SB, type 뽑아준다.
    immgen immedgen(
        .inst ();
        .ImmSrc ();
        .Imm ();

    );
    */
endmodule
`default_nettype wire
