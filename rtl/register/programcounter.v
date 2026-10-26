module programcounter(input clk, reset, output [31:0]pc);

    /* PC counter */
    wire [31:0]oca;
    wire [31:0]nxt;
    assign nxt = reset ? 0 : oca;
    CRA32 cra(pc,32'd4,1'b0,oca,);
    parallel32 pa(nxt,clk,1'b1,pc);


endmodule