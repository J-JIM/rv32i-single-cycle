module dmem(input [31:0]addr, wdata, input MemRead, MemWrite, clk, output [31:0]rdata);
    /* data memory(dmem) 
        wdata : write data, rdata: read data
        addr로 주소에 맞는 데이터를 저장하는 모듈 조합 논리(combinational circuit) 사용
    */

    reg [31:0]mem[0:31];
    assign rdata = mem[addr[6:2]];


    always @(posedge clk) begin
        if(MemWrite == 1) mem[addr[6:2]] <= wdata;
    end

    

endmodule