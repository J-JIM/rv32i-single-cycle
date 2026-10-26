module parallel32(input [31:0]d,input clk, load, output [31:0]s);

    wire [31:0]m;

    genvar i;
    generate
         
        for(i = 0; i < 32; i = i + 1)begin : df
            assign m[i] = load ? d[i] : s[i];
            DFF df(m[i], clk, s[i]);
        end
    endgenerate

endmodule