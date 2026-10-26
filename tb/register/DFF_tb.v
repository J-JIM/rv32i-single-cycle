module DFF_tb;

    reg d, clk; //주기적으로 값이 바뀜 
    wire s; //값을 읽기만 함. wire로 진행.
    wire tmp;

    assign tmp = ~clk; //tb도 module이기에 WIRE후 assign 가능.
    DFF uut(d,clk,s);

    /*이번에는 d,clk은 다이어그램 시나리오와 같이 임의적으로 진행항 것이다.
      모니터는 해당 master,slave가 변하는 값을 출력하기 위함이다. 
      
      monitor에서는 계산식 (expression)을 넣을수 없음.
      그래서 중간 wire로 넣어서 assign 하지 않으면 ~clk 같이 식(expression)으로 된 것이 오면 오류를 출력한다.
    */
    initial begin
        $monitor("d = %b, mc = %b, qm = %b, output = %b", d, tmp,uut.qm,s);

        d = 0;clk = 0; #10;
        d = 1;clk = 0; #10;
        d = 1;clk = 1; #10;
        d = 0;clk = 1; #10;
        d = 1;clk = 1; #10;
        d = 0;clk = 1; #10;
        d = 0;clk = 1; #10;
        d = 1;clk = 1; #10;
        d = 1;clk = 0; #10;
        d = 0;clk = 0; #10;
        d = 0;clk = 1; #10;

        $finish;
    end

endmodule