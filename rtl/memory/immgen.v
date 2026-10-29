module immgen(input [31:0]inst, input [1:0]ImmSrc, output reg [31:0]Imm);

    /* immgen source에 따른 I,S,SB,U type 설정*/
    always @(*) begin
        case(ImmSrc)
            2'b00 : imm = {{20{inst[31]}},inst[31:20]};// I-type , sign-extention
            2'b01 : imm = {{20{inst[31]}},inst[31:25],inst[11:7]};// S-type
            2'b10 : imm = {{19{inst[31}}, inst[31], inst[7], inst[30:25], inst[11:8],1'b0};// SB-type
            2'b11 : imm = {inst[31:12], 12'b0};// U-type
            default : imm = 32'd0;
        endcase
    end

endmodule
