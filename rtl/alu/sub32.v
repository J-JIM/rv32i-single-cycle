module sub32(input [31:0]a,b, output [31:0]s, output Cout); //subtract module
    
    CRA32 CA(a,~b,1'b1,s,Cout);

endmodule