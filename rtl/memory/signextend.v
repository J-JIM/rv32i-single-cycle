module signextend(input [11:0]data, output [31:0]s);

    assign s = {{20{data[11]}}, data};

    /* fault 3종
        1'b0로 signextend하면 MSB가 1이여도 항상 0으로 하니 fault가 됨.

        비트를 12비트가 아닌 11비트로 잡으면 데이터 원본을 건드는 것이니 오류 발생.
        순서를 뒤집게 된다면, 원본까지 오염이 되기 때문 안된다 (20{data[11]}, data); 
    */
endmodule