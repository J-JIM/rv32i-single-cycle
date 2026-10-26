module example(x1, x2, x3, x4, f);
    input x1, x2, x3, x4;
    output reg f;
    always @(*)
        f = (x1&x2&x3) | (x1&x2&x4) | (x1&x3&x4) | (x2&x3&x4);
        
endmodule