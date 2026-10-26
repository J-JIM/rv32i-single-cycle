module ismem_tb;

    // setting wire and variable
    reg [31:0]adr;
    reg [31:0]mirror[0:31];

    wire [31:0]s;
    integer i, fails;

    ismem uut(adr, s); //instance
    
    task check(input [31:0]ar);
        begin
            adr = ar; #5; //delay 5
            if(s !== mirror[adr/4]) fails = fails + 1;
        end
    endtask

    initial begin
        fails = 0;
        $readmemh("program.hex", mirror);

        $monitor("input = %h, output = %h", adr, s);
        check(32'd0);
        check(32'd124);
        check(0);check(4);check(8);check(16);
        check(32'd4);
        check(32'd8);
        
        for(i = 0; i < 10; i++)begin
            check(($random & 31) * 4);
        end
        $display("fails = %1d", fails);
        if(fails > 0) $display("fail tb");
        else $display("success tb");
        $finish;
    end
endmodule