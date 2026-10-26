module signextend_tb;

    wire [31:0]s;
    
    reg [11:0]data;
    integer i, fails;
    /* edge nodes 
        1. 양끝단. data = 12'h000, data = 12'hFFF;
            -> 예상 기댓값. s = 0000_0000_0000_0000_0000_0000_0000_0000
                         s = 1111_1111_1111_1111_1111_1111_1111_1111

        2. 설계 코드 분기(경계값) data = 12'h7FF, 12'h111
            -? 예상 기댓값. s = 0000_0000_0000_0000_0000_0111_1111_1111
                         s = 1111_1111_1111_1111_1111_0001_0001_0001

    */
    signextend uut(data, s);
    task check(input [11:0]op);
        reg [31:0] exp;
        reg [11:0]paste;
        begin
            paste = op;
            data = op;#5;
            exp = data[11] ? data - (2**12) : data;

            if(s !== exp) fails = fails +1;
        end
    endtask
    
    initial begin
        fails = 0;
        $monitor("data = %b, output = %b", data, s);

        check(12'h000);
        check(12'hFFF);
        check(12'h7FF);
        check(12'h800);

        for(i = 0; i < 9; i++) check($random);

        if(fails > 0) $display("fails tb : %0d", fails);
        else $display("success tb");
        $finish;
    end

endmodule