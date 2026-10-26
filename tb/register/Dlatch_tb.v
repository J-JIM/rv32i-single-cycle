module Dlatch_tb;

    wire q;     //tb에서 읽기만 하는것 -> initial/always에서 데이터 변하는것이 아님 -> wire 사용.
    reg d, clk; //tb을 흔드는 신호 -> initial에서 좌변에 데이터 옴 reg를 사용.

    Dlatch d1(d, clk, q);

    /*각각의 데이터가 변경되고 난뒤에 시간의 변화가 필요함. 
      시간의 변화가 없으면 line 10~ 13이 t=0일때 동시에 바뀌게 되어 latch 동작을 관측할수 없음.
      그래서 각데이터 변화 이후 #10으로 시뮬레이션 시간을 조정해줘야함.
    */
    initial begin
        $monitor("clk = %b, data = %b, output = %b", clk, d, q);
        clk = 1; d= 0; #10; 
        clk = 1; d= 1; #10; 
        clk = 0; d= 1; #10; 
        clk = 0; d= 0; #10;

    $finish;
    end

endmodule