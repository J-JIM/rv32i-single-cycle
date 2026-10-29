module immgen(input [31:0]inst, input [1:0]ImmSrc, output reg [31:0]Imm);

    /* immgen source에 따른 */
    always @(*) begin
        case(ImmSrc) 
            2'b00 : // I-type
            2'b01 : // S-type
            2'b10 : // SB-type
            2'b11 : // U-type
            default : imm = 32'd0;

        endcase
    end

endmodule