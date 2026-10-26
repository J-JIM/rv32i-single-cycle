module sub32_tb;

    reg [31:0]a, b;
    wire Cout;
    wire [31:0]s;
    integer i;
    integer fails;

    sub32 uut(a,b,s,Cout);


    /* task
        반복된 조건을 일일이 치기 귀찮을때 조건을 잡아주는 방식.
    */
    task check(input [31:0]aa, bb);
        begin
            a = aa; b = bb; #10;
            if(s !== a - b) fails = fails + 1;
            if(Cout !== (a >= b)) fails = fails +1;
        end
    endtask

    /* edge node case 
        a = 0, b = 32'hFFFFFFFF : 양끝단 경계.
        a = 32'h80000000, b = 32'hFFFFFFFF : 양의 최댓값 과 음의 최솟값.
            -> 결과 s = 80000001, Carry out = 0
        
        a = 0; b = 0; : 각 값의 경계값.
            -> 결과 s = 00000000, Carry out = 1
    */
    initial begin
        fails = 0;
        $monitor("%h + %h = %h , carryout = %b", a, b, s, Cout);
        check(0, 32'hFFFFFFFF); 
        check(32'h80000000 ,32'hFFFFFFFF);
        check(0, 0); 

        for(i = 0; i < 10; i++)begin
            check($random, $random);
        end
        if(fails > 0) $display("Error sub32");
        else $display("PASS : 3edges + 10 random");
        
        $finish;
    end
endmodule