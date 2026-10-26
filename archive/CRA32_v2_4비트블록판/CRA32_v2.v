module CRA32_v2(input [31:0]a, b, input Cin, output [31:0]s, output Cout);

    wire k1,k2,k3,k4,k5,k6,k7;

    CRA4 CA1(a[3:0],   b[3:0],   Cin, s[3:0],   k1);
    CRA4 CA2(a[7:4],   b[7:4],   k1,  s[7:4],   k2);
    CRA4 CA3(a[11:8],  b[11:8],  k2,  s[11:8],  k3);
    CRA4 CA4(a[15:12], b[15:12], k3,  s[15:12], k4);
    CRA4 CA5(a[19:16], b[19:16], k4,  s[19:16], k5);
    CRA4 CA6(a[23:20], b[23:20], k5,  s[23:20], k6);
    CRA4 CA7(a[27:24], b[27:24], k6,  s[27:24], k7);
    CRA4 CA8(a[31:28], b[31:28], k7,  s[31:28], Cout);

endmodule
