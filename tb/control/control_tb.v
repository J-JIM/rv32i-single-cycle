module control_tb;

    //포트 설정.
    reg [6:0]opcode;
    wire branch, MemRead, MemWrite,AluSrc, MemtoReg, RegWrite;
    wire [1:0]Aluop;
    integer i, fails;

    // 모듈 인스턴스 input 1, output 7
    control uut(opcode, branch, MemRead, MemWrite,AluSrc,MemtoReg,RegWrite, Aluop);

    task check(input [6:0]op);
        begin
            opcode = op;#5;
        end
    endtask

    task fail(input [7:0]exp);
        begin
            if({AluSrc,MemtoReg,RegWrite,MemRead,MemWrite,branch,Aluop} !== exp ) fails = fails + 1;
        end
    endtask

    initial begin
        fails = 0;
        $monitor("op: %b, branch = %b, MemRead = %b, MemWrite = %b, AluSrc = %b, MemtoReg = %b, RegWrite = %b, Aluop = %b",opcode, branch, MemRead,MemWrite, AluSrc, MemtoReg,RegWrite,Aluop);

        check(7'b0110011);
        fail(8'b00100010);

        check(7'b0000011);
        fail(8'b11110000);

        check(7'b0100011);
        fail(8'b1x001000);
        
        check(7'b1100011);
        fail(8'b0x000101);

        opcode = 7'b1111111; #5;
        if({branch,MemRead,MemWrite,AluSrc,MemtoReg,RegWrite,Aluop} !== 8'b00000000) fails = fails + 1;

        if(fails > 0) $display("fails tb");
        else $display("success tb");
        $finish;
    end

endmodule