module DFF(input d, c, output qs);
    //여기서 qs는 reg를 안함 -> initial / always에서 좌변에 오지 않음 (대입을 안받음)
    wire qm;
    Dlatch master(d, ~c, qm);
    Dlatch servant(qm,c, qs);

endmodule


// input clk, d, output q
/* 
always @ (posedge clk)
 q <= d ; // un-blocking  <= sequential logic일때는 blocking이 아닌 un-blocking으로 진행해야한다.


다이어그램 그려야하고, 맞는지 틀린지도 확인해야한다.




*/