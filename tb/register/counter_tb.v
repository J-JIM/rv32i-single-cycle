module counter_tb;

    wire [31:0]pc;
    reg clk, reset;
    integer i,fails;
    counter uut(clk, reset, pc);

    task check(input c, rst);
        reg [31:0]tmp;
        begin
            reset = rst;
            clk = 0; #5; clk=1; #5;
            tmp = (rst == 1) ? 0 : tmp + 4;

            if(pc !== tmp) fails = fails + 1;
        end
    endtask

    initial begin
        fails = 0;
        $monitor("pc = %h, reset = %b", pc, reset);

        check(1,1);
        check(0,1);
        check(0,1);
        check(1,0);
        check(1,0);
        check(1,1);
        check(0,0);

        for(i = 0; i < 10; i= i+1)begin
            check($random,$random);
        end
        if(fails > 0) $display("fails tb");
        else $display("success tb");
        $finish;
    end

endmodule