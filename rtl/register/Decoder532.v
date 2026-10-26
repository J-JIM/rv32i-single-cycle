module Decoder532(input [4:0]d, output [31:0]out);

    genvar k;
    
    /* Decoder
       input N, output 2^N;

       one-hot output 사용.
       데이터에 따라 출력 위치 routing이 달라지는것. -> Demux 설명이였음 문제.
    */
    generate 
        for(k = 0; k < 32; k = k + 1) begin : dec
            assign out[k] = (d ==k );
        end
    endgenerate
    
endmodule