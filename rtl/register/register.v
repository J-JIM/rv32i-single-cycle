module register(input [31:0]d, input c, output [31:0]s);

    //32bit register
    genvar i;
    generate
        for(i = 0; i < 32; i= i+1)begin : ff
            DFF ff(d[i],c,s[i]);
        end
    endgenerate
endmodule
