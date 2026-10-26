module Dlatch(input d, input c, output reg q);
    always @(*)
        if (c) q = d;

    //else를 넣게 된다면 여기서는 조합회로로서 기억을 하지 못하게 된다.
    //else를 넣으면 AND 게이트가 됨.
endmodule