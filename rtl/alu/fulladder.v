module fulladder(input a1, b1, Cin, output Cout, s);

    assign s = (a1 ^ b1) ^ Cin;
    assign Cout = (a1 & b1) | ((a1 ^ b1) & Cin);

endmodule 