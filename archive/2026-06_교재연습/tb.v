module tb;
    reg x1, x2, x3, x4;
    wire f;
    integer i;
    example uut(x1,x2,x3,x4, f);

    initial begin
        $monitor("%b%b%b%b -> f =%b", x1, x2, x3, x4, f);
        for(i = 0; i < 16; i= i+1)begin
            {x1,x2,x3,x4} = i;
            #10;
        end
        $finish;
    end
endmodule