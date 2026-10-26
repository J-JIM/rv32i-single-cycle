module CRA4(input [3:0]a,b,input Cin, output [3:0]s, output Cout);

    wire c1,c2,c3;

    fulladder fa0(a[0],b[0],Cin,c1,s[0]);
    fulladder fa1(a[1],b[1],c1,c2,s[1]);
    fulladder fa2(a[2],b[2],c2,c3,s[2]);
    fulladder fa3(a[3],b[3],c3,Cout,s[3]);

endmodule
