module registerfile(input [31:0]d, input [4:0] id, ra1,ra2, input clk, RegWrite, output [31:0]s1, s2);

    wire [31:0]dec;   //initial/always 에서 좌변에 할당 X
    wire [31:0]slot[0:31]; // 2차원 배열을 선언하는 방식. -> 여기서 처음 접함.
    wire [31:0]wr_en;
    assign wr_en = (RegWrite == 1) ? dec : 0;
    Decoder532 dec5(id,dec); //one-hot으로 나온 결과를 dec에 넣음.
    

    /* dec5 인스턴스 밑으로 둔 이유
       decoder output(one-hot)에서 하나씩 레지스터에 load로 보내줘야하기 때문임.
    */
    

    genvar i;
    generate
        for(i = 0; i < 32; i = i + 1) begin : pa
            parallel32 pa(d,clk,wr_en[i],slot[i]);
        end
    endgenerate

    //Read
    assign s1 = (ra1 == 0) ? 0 : slot[ra1];
    assign s2 = (ra2 == 0) ? 0 : slot[ra2];
endmodule