module alu_tb;

    localparam ALU_ADD = 2'b00,
               ALU_SUB = 2'b01,
               ALU_AND = 2'b10,
               ALU_OR =  2'b11;
    // variable 설정
    reg [31:0]a,b;
    reg [1:0] op;
    wire[31:0]res;
    wire zero; //!zero를 사용 안하고 있음. 근데 이 line zero와 uut에 들어간 zero가 겹치지 않나?
    integer i, fails;
    alu uut(a,b,op,res,zero);

    // check edge case and sequential time
    task check(input [31:0]op1,op2, input [1:0]cmd);
        reg [31:0] exp; // expection value
        
        begin
            a = op1; b = op2; op = cmd; #10;
            case(op)
                ALU_ADD: exp = a + b;
                ALU_SUB: exp = a - b;
                ALU_AND: exp = a & b;
                ALU_OR : exp = a | b;
                default: exp = 32'b0;
            endcase
             
            if(res !== exp) fails = fails + 1;
            if(zero !== (exp == 0)) fails = fails + 1;
        end
    endtask

    // simulation 
    initial begin
        fails = 0;
        $monitor("a = %h, b = %h, cmd = %b, output = %h", a,b,op, res);
        check(32'hFFFFFFFF, 32'hFFFFFFFF, 2'b00);
        check(32'h00000000, 32'h00000000, 2'b01);
        check(32'hABEDEFAB, 32'hAAAAAAAA, 2'b10);
        check(32'hABCDEFAB, 32'hBBABABAB, 2'b11);

        for(i = 0; i < 5; i++)begin
            check($random, $random, $random);
        end
        if(fails > 0) $display("fail tb");
        else $display("success tb");
        $finish;
    end

endmodule