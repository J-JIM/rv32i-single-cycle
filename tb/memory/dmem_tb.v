module dmem_tb;

    /*dmem(data memory) testbench */

    wire [31:0] rdata;
    reg [31:0] addr, wdata;
    reg clk, Rmem, Wmem;
    
    reg [31:0] mirror [0:31];
    integer i, fails;

    dmem uut(addr, wdata, Rmem, Wmem, clk, rdata);

    //fails 처리
    task wr(input [31:0] adr, wd, input Wm);
        begin
            addr = adr; wdata = wd; Wmem = Wm;
            clk = 0; #5; clk = 1; #5;
            if(Wmem == 1) mirror[adr/4] = wd;
            
        end
    endtask

    task rd(input [31:0] adr);
        begin 
            addr = adr; #5;
            if(rdata !== mirror[adr/4]) begin
                fails = fails + 1; 
                $display("FAIL : addr = %h, exp = %h, real = %h", addr, mirror[addr/4], rdata);
            end
        end
    endtask

    initial begin
        fails = 0;
        Rmem = 1; 
        $monitor("clk = %b, addr = %h, wdata = %h, Readmem = %h, Writemem = %h, output = %h",clk,addr, wdata,Rmem,Wmem,rdata);

        //test1
        wr(40, 32'd7,0);
        rd(40);

        //test2
        wr(40,32'd9,1);
        rd(40);

        //test3 (양끝)
        wr(0,32'd6,1); wr(124, 32'd4,1);
        rd(0); rd(124);

        //test4 (전이)
        wr(40,32'd1,1);wr(44,32'd0,1);wr(40,32'd9,1);
        rd(40);rd(44);rd(40);

        //test5 (시간)
        addr = 40; wdata = 32'd6; Wmem = 1; #5;
        Wmem = 0;rd(40);

        addr = 124; wdata = 32'd5; Wmem = 1;clk = 0; #5;
        Wmem = 0; rd(124); 

        //test 6(랜덤)
        for(i = 0; i < 3; i++) begin
            wr(($random & 31) * 4, $random, 1);
            rd(($random & 31) * 4);
        end

        if(fails > 0) $display("fails tb");
        else $display("success tb");
        $finish;
    end


endmodule