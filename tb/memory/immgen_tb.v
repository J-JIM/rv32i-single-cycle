module immgen_tb;
    /* immgen testbench */
    reg  [31:0] inst;
    reg  [1:0]  ImmSrc;
    wire [31:0] Imm;
    integer     fails;

    immgen uut(.inst(inst), .ImmSrc(ImmSrc), .Imm(Imm));

    task check(input [1:0]src, input [31:0] inst_in, exp);
        begin
            inst = inst_in;
            ImmSrc = src; #5;
            if(Imm !== exp) begin
                fails = fails + 1;
                $display("  FAIL ImmSrc=%b inst=%h : Imm=%h, exp=%h", src, inst_in, Imm, exp);
            end
        end
    endtask

    initial begin
        fails = 0;

        // ---- I-type (00) : 12비트를 부호확장 ----
        check(2'b00, 32'h00A00313, 10);                // 앵커 - program.hex 1행 addi x6,x0,10
        check(2'b00, 32'hFFF00013, -1);                // B+C 전부 1 → 부호확장
        check(2'b00, 32'h7FF00013, 2047);              // A+C 최대 양수 (부호비트 0)
        check(2'b00, 32'h80000013, -2048);             // A+C 최소 음수 (부호비트 1) ← 경계 짝

        // ---- S-type (01) : inst[31:25] + inst[11:7] 두 조각 ----
        check(2'b01, 32'h00552A23, 20);                // sw x5,20(x10) - 상위조각 0 (약한 케이스)
        check(2'b01, 32'h7E002FA3, 2047);              // 상위7+하위5 전부 1 ← 상위조각 검증
        check(2'b01, 32'hFE002FA3, -1);                // 전부 1 + 부호확장

        // ---- SB-type (10) : inst[7]→imm[11] 재배치, imm[0]=0 ----
        check(2'b10, 32'h00000080, 2048);              // walking-one inst[7]만 1 → imm[11]
        check(2'b10, 32'hFE000FE3, -2);                // 음수 짝수 (imm[0]=0 유지)
        check(2'b10, 32'h7E000FE3, 4094);              // 최대 양수 짝수 (13비트)

        // ---- S vs SB : 같은 자극, 한 선만 다르다 ----
        check(2'b01, 32'h00000080, 1);                 // 같은 inst를 S로 → imm[0] (SB는 imm[11])

        // ---- U-type (11) : 부호확장 없음, 하위 12비트 0 ----
        check(2'b11, 32'h12345ABC, 32'h12345000);      // 하위 12비트(ABC) 버려지나
        check(2'b11, 32'h00001000, 4096);              // inst[12]만 1 → 유효 경계 안쪽
        check(2'b11, 32'h00000800, 0);                 // inst[11]만 1 → 버려져야 0 ← 경계 짝

        if(fails > 0) $display("fails tb : %0d", fails);
        else $display("success tb");
        $finish;
    end

endmodule
