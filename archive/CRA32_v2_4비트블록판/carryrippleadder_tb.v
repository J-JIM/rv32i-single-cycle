module carryrippleadder_tb;

    reg [3:0]a, b; //input and output     
    wire c1, c2, c3;    //carryout 
    wire [4:0] s;
    integer i;          //loop variable

    carryrippleadder uut(a, b, s);   //func

    initial begin
        $monitor("%0d + %0d = %0d", a, b, s);
        for(i = 0; i < 256; i++) begin
            {a[3],a[2],a[1],a[0],b[3],b[2],b[1],b[0]} = i;
            #10;
        end    
            
        $finish;
    end
endmodule