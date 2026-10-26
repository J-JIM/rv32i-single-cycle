module CRA4_tb;

    wire Cout;
    wire [3:0]s;
    reg [3:0]a,b; // input bits
    reg Cin;
    integer i;

    CRA4 uut(a,b,Cin,s,Cout);

    initial begin
        $monitor("%d + %d = %d , Carry_out = %b", a, b, s,Cout);
        for ( i = 0; i < 512; i++) begin
            {a,b,Cin} = i;
            #10;
            if({Cout, s} !== a + b + Cin) $display("Fail %d + %d = %d", a, b, s);

        end
        $display("PASS : 512 combos checked");
        $finish;
    end

endmodule;