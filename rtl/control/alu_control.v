module alu_control(input func7, input [1:0]Aluop,input [2:0]func3, output reg [1:0]op);
    /*  alu_control 모듈 
        control에서 받은 Aluop와 ismem의 func7,func3을 합쳐서
        연산 방식을 alu에게 보내주는 모듈이다.

        데이터패스에서 Control Aluop, ismem[30, 14-12]를 받는다.
    */

    localparam op_add  = 2'b00,
               op_sub  = 2'b01,
               op_func = 2'b10;

    // case의 aluop만 들어감. 2'b10일때만 func를 사용.
    // 현재 add만 사용하기 때문에 func를 분기 나누지 않은 것.
    // sub 구현시 if로 branch 나누기.
    always @(*) begin
        case(Aluop) 
            op_add  : op = 2'b00;
            op_sub  : op = 2'b01;
            op_func : op = 2'b00;
            default : op = 2'b00;
        endcase
    end

endmodule