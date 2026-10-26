module alu(input [31:0]a, b, input [1:0] op, output reg [31:0]s, output zero);

    localparam ALU_ADD = 2'b00,
               ALU_SUB = 2'b01,
               ALU_AND = 2'b10,
               ALU_OR = 2'b11;

    // 연산 유닛들
    wire [31:0] isum, g_and, g_or, b_in;
    wire        ctrl;

    assign ctrl = op[0];
    assign b_in = ctrl ? ~b : b;
    CRA32 cra(a,b_in,ctrl,isum,);

    assign g_and = a & b;
    assign g_or  = a | b;


    always @(*) begin
        case(op)
            ALU_ADD,
            ALU_SUB: s = isum;
            ALU_AND: s = g_and;
            ALU_OR : s = g_or;
            default: s = 32'b0;
        endcase
    end
    assign zero = ~|s;
endmodule
