module alu_control_tb;

    // alu_control.v 모듈 tb
    
    // 포트 배선 선언.
    reg  func7;
    reg  [1:0] Aluop;
    reg  [2:0] func3;
    wire [1:0] op;

    integer fails;

    alu_control uut(func7, Aluop, func3, op);

    task check(input [1:0]tb_op, exp);
        begin
            Aluop = tb_op; #5;
            if(op !== exp) fails = fails + 1;
        end
    endtask

    initial begin
        fails = 0;
        $monitor("Aluop = %b, func7 = %b, func3 = %b, result_op = %b",Aluop, func7, func3, op);


        // Aluop로 실제 Alu에 배선된 op와 맞는지 check.
        check(2'b00, 2'b00);
        check(2'b01, 2'b01);
        check(2'b10, 2'b00);
        check(2'b11, 2'b00); //default fails check.

        if(fails > 0) $display("fails tb");
        else $display("success tb");
        $finish;
    end

endmodule