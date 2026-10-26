module parallel32_tb;

    /*assign variable은 할당되는것들.*/
    reg [31:0] d;
    reg clk, load;
    wire [31:0]s;
    integer i, fails;

    parallel32 uut(d,clk,load,s);
    task check(input [31:0]dd, input ld);
        reg [31:0] before;
        begin
            begin

                before = s;
                load = ld; d = dd;
                clk = 0; #5; clk = 1; #5;
                if(s !== (load ? dd : before)) fails = fails + 1;
            end
        end
    endtask

    initial begin
        $monitor("data = %h, output = %h", d, s);

        fails = 0;
        check(32'hA,1);
        check(32'hB,0); //A가 유지되는지 확인
        check(32'hC,1); //C로 데이터 새로 출력이 되는지.
        check(32'hE,0);
        
        if(fails > 0) $display("Fails check");
        else $display("Success test case 4edges");
        $finish;
    end

endmodule