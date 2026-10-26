module ismem(input [31:0]addr, output [31:0] inst);
    /* 명령어 메모리 (instruction memory) */
    reg [31:0]slot[0:31];
    initial begin
        $readmemh("program.hex", slot);
        
    end
    assign inst = slot[addr[6:2]];
endmodule