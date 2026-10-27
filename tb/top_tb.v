module top_tb;
    /// datapath single-cycle add testbench

    reg clk, reset;
    top uut(.clk(clk), .reset(reset));

    /// clock period 10ns
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #5; reset = 0;
        #31;
        $display("%d", uut.regfile.slot[5]);
        $finish;
    end

endmodule