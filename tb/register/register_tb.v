module register_tb;

    reg [31:0]d; // initial / always에서 값을 할당 받음 (좌변)
    wire [31:0]s; //initial / always에서 값을 할당 받지 않음
    reg clk;     //clk wire initial / always에서 값을 할당 받음. 

    register uut(d,clk,s);

    initial begin
        $monitor("data = %h, clk = %b, output = %h",d,clk,s);

        d = 32'hAAAAAAAA; clk = 0; #10;
        d = 32'hAAAAAAAA; clk = 1; #10;
        d = 32'hABCDEFAB; clk = 1; #10;
        d = 32'hBBBBBBBB; clk = 1; #10;
        d = 32'hABCDEFAB; clk = 0; #10;
        d = 32'hABCDEFAB; clk = 0; #10;
        d = 32'h00000000; clk = 1; #10;
        d = 32'hFFFFFFFF; clk = 1; #10;

        
        $finish;
    end

endmodule