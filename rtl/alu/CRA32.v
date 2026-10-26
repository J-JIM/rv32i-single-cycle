module CRA32(input [31:0]a, b, input Cin, output [31:0]s, output Cout);

    wire c1,c2,c3,c4,c5,c6,c7,c8,c9;
    wire c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20;
    wire c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31;

    fulladder fa0(a[0],b[0],Cin,c1,s[0]);
    fulladder fa1(a[1],b[1],c1,c2,s[1]);
    fulladder fa2(a[2],b[2],c2,c3,s[2]);
    fulladder fa3(a[3],b[3],c3,c4,s[3]);
    fulladder fa4(a[4],b[4],c4,c5,s[4]);
    fulladder fa5(a[5],b[5],c5,c6,s[5]);
    fulladder fa6(a[6],b[6],c6,c7,s[6]);
    fulladder fa7(a[7],b[7],c7,c8,s[7]);
    fulladder fa8(a[8],b[8],c8,c9,s[8]);
    fulladder fa9(a[9],b[9],c9,c10,s[9]);
    fulladder fa10(a[10],b[10],c10,c11,s[10]);
    fulladder fa11(a[11],b[11],c11,c12,s[11]);
    fulladder fa12(a[12],b[12],c12,c13,s[12]);
    fulladder fa13(a[13],b[13],c13,c14,s[13]);
    fulladder fa14(a[14],b[14],c14,c15,s[14]);
    fulladder fa15(a[15],b[15],c15,c16,s[15]);
    fulladder fa16(a[16],b[16],c16,c17,s[16]);
    fulladder fa17(a[17],b[17],c17,c18,s[17]);
    fulladder fa18(a[18],b[18],c18,c19,s[18]);
    fulladder fa19(a[19],b[19],c19,c20,s[19]);
    fulladder fa20(a[20],b[20],c20,c21,s[20]);
    fulladder fa21(a[21],b[21],c21,c22,s[21]);
    fulladder fa22(a[22],b[22],c22,c23,s[22]);
    fulladder fa23(a[23],b[23],c23,c24,s[23]);
    fulladder fa24(a[24],b[24],c24,c25,s[24]);
    fulladder fa25(a[25],b[25],c25,c26,s[25]);
    fulladder fa26(a[26],b[26],c26,c27,s[26]);
    fulladder fa27(a[27],b[27],c27,c28,s[27]);
    fulladder fa28(a[28],b[28],c28,c29,s[28]);
    fulladder fa29(a[29],b[29],c29,c30,s[29]);
    fulladder fa30(a[30],b[30],c30,c31,s[30]);
    fulladder fa31(a[31],b[31],c31,Cout,s[31]);



endmodule