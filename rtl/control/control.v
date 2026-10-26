module control(input [6:0]opcode, output reg branch, MemRead, MemWrite, AluSrc, MemtoReg, RegWrite, output reg [1:0]Aluop);
    /*  control unit module

        instruction memory에서 받은 opcode [7bit]를 control unit이
        기능을 수행하게끔 제어하는 모듈.

        데이터패스에 Branch(beq), MemRead, MemWrite, MemtoReg,AluOp, AluSrc, RegWrite 존재.
    */

    //opcode 기본 설정. RISC-V 명령코드 참조.
    localparam R_format = 7'b0110011,
               lw       = 7'b0000011,
               sw       = 7'b0100011,
               beq      = 7'b1100011;


    //input opcode의 변함에 따른 값 수정받는 코드.
    //case opcode에 따른 값을 변화 시켜주는 것이다.
    always @(*) begin   //combinational circuit
        case(opcode)
            default :   begin AluSrc = 0; MemtoReg = 0; RegWrite =0; MemRead = 0; MemWrite = 0; branch = 0; Aluop =2'b00; end   //예약어 이름표.
            R_format:   begin AluSrc = 0; MemtoReg = 0; RegWrite =1; MemRead = 0; MemWrite = 0; branch = 0; Aluop =2'b10; end
            lw:         begin AluSrc = 1; MemtoReg = 1; RegWrite =1; MemRead = 1; MemWrite = 0; branch = 0; Aluop =2'b00; end
            sw:         begin AluSrc = 1; MemtoReg = 1'bx; RegWrite =0; MemRead = 0; MemWrite = 1; branch = 0; Aluop =2'b00; end
            beq:        begin AluSrc = 0; MemtoReg = 1'bx; RegWrite =0; MemRead = 0; MemWrite = 0; branch = 1; Aluop =2'b01; end
        endcase
    end

endmodule