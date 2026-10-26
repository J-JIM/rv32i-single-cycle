module halfadder_tb;

    reg  a, b;
    wire s, cout;
    integer i;

    halfadder uut(a,b,cout,s);

    initial begin
        $monitor("a=%b, b = %b -> s=%b, Cout=%b",a,b,s, cout);
        for(i = 0; i < 4; i = i+1) begin
            {a,b} = i;
            #10;
        end;
        $finish;
    end



endmodule;