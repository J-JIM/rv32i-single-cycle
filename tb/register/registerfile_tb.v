module registerfile_tb;

    reg [31:0]d;
    reg [4:0] load,ad1,ad2;
    reg [31:0]st[0:31];
    reg clk,RegWrite;
    
    wire [31:0]s1,s2;
    
    integer i,fails;
    registerfile uut(d,load,ad1,ad2,clk,RegWrite,s1,s2);

    task check(input [31:0]dd, input [4:0]ld,a1,a2, input wr_rg);
        integer j;
        reg [31:0] e1,e2;
        begin
            d = dd; load = ld; ad1 = a1; ad2=a2;
            RegWrite = wr_rg;
            st[ld] = (wr_rg == 1) ? dd : st[ld];
            clk = 0; #5; clk=1; #5;
            for(j = 0; j < 32; j = j + 1)begin
                if(uut.slot[j] !== st[j]) fails = fails +1;
                //같은 주소 참조안하게 잡기. ad1 == ad2면 안됨. edgecase
            end
            e1 = (ad1 == 0)? 0 : st[ad1];
            e2 = (ad2 == 0)? 0 : st[ad2];

            if(s1 !== e1) fails = fails+1;
            if(s2 !== e2) fails = fails+1;
        end
    endtask

    /* edge case  -> MUX 포함 이전
        1. load data 양 끝단을 사용 load = 0; load = 31;
        2. 레지스터 값이 유지 되며 값을 변경할때 바뀌는지
        3. 
    */

    initial begin
        fails = 0;
        $monitor("data = %h, load = %h, clk = %b ,output1 = %h, output2 = %h",d,load,clk,s1,s2);
        check(32'hABCDEFAB, 1,1,1,1);
        check(32'hFFFFFFFF, 2,8,14,0);
        check(32'hDEADBEEF, 3,0, 3,0);
        check(32'hDEADBEAF, 3, 0, 0,1);
        for(i = 0; i < 10; i++) begin
            check($random,$random,$random,$random, {$random} % 2);
        end

        if(fails > 0) $display("Fail tb");
        else $display("Success tb");
        $finish;
    end
endmodule