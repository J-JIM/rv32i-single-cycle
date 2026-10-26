module Decoder532_tb;

    reg [4:0]d;
    wire [31:0]s;

    integer i, fails;

    Decoder532 uut(d,s);

    initial begin
        $monitor("input data = %b, output = %b", d, s);
        fails = 0;
        for(i = 0; i < 32; i = i+1)begin
            {d} = i; #5;
            if(s !== (1 << d)) fails = fails + 1;
        end
        if(fails > 0 ) $display("fails decoder module");
        else $display("success decoder module");
        $finish;
    end

endmodule