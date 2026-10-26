module CRA32_tb;

    reg [31:0]a, b;
    reg Cin;
    wire Cout;
    wire [31:0]s;
    integer i;
    integer fails;
    
    CRA32_v2 uut(a,b,Cin,s,Cout);

    initial begin
        fails = 0;
        a = 0; b = 0; Cin = 0;
        #10; if({Cout, s} !== a + b + Cin) begin fails = fails + 1; $display("Fail edge case");end

        a = 32'hFFFFFFFF;  b = 0; Cin = 1;
        #10; if({Cout, s} !== a + b + Cin) begin fails = fails + 1; $display("Fail edge case");end

        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; Cin = 1;
        #10; if({Cout, s} !== a + b + Cin) begin fails = fails + 1; $display("Fail edge case");end

        a = 32'h80000000; b = 32'h80000000; Cin = 0;
        #10; if({Cout, s} !== a + b + Cin) begin fails = fails + 1; $display("Fail edge case");end

        a = 0; b = 0; Cin = 0;
        #10; if({Cout, s} !== a + b + Cin) begin fails = fails + 1; $display("Fail edge case");end

        a = 32'hAAAAAAAA; b = 32'h55555555; Cin = 0;
         #10; if({Cout, s} !== a + b + Cin) begin fails = fails + 1; $display("Fail edge case");end


        $monitor("%h + %h = %h, Carry = %d", a, b, s, Cin);
        for(i = 0; i < 10000; i = i+1)begin
            a = $random; b = $random; Cin = $random;
            #10;
            if({Cout, s} !== a + b + Cin) begin fails = fails + 1; $display("Fail %h + %h + %b", a, b, Cin); end
        end
        if(fails == 0) $display("PASS : 5 edges + 10000 random");
        else $display("%0d Fails", fails);
        $finish;

    end

endmodule