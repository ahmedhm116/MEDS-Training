module tb_controller;
    logic  clk = 0  , rst_n, start, count_zero;
    logic [1:0] q_bits;
    logic sub, add, done, shift_en;

    always #5 clk = ~clk;

    controller u1 (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .done(done),
        .count_zero(count_zero),
        .q_bits(q_bits),
        .sub(sub),
        .add(add),
        .shift_en(shift_en)
    );

    task automatic check_bits(input logic [1:0] q_in, input logic exp_sub, exp_add, string name);
        q_bits = q_in;
        @(posedge clk); #1;
        if (sub !== exp_sub || add !== exp_add)
            $display("Test failed: %s, expected sub=%0b add=%0b, actual sub=%0b add=%0b", name, exp_sub, exp_add, sub, add);
        else
            $display("Test passed: %s, sub=%0b add=%0b", name, sub, add);
        @(posedge clk); #1;
    endtask

    task automatic check_done(input logic expected, string name);
        @(posedge clk); #1;
        if (expected !== done)
            $display("Test failed: %s, Expected: %0b, Actual: %0b", name, expected, done);
        else
            $display("Test passed: %s, value = %0b", name, done);
    endtask

    initial begin
        $dumpfile("tb_controller.vcd");
        $dumpvars(0, tb_controller);
        rst_n = 0;
        start = 0;
        count_zero = 0;
        shift_en = 0;
        @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        start = 1;
        check_bits(2'b00, 1'b0, 1'b0, "q_bits=00");
        check_bits(2'b01, 1'b1, 1'b0, "q_bits=01");
        check_bits(2'b10, 1'b0, 1'b1, "q_bits=10");
        check_bits(2'b11, 1'b0, 1'b0, "q_bits=11");
        check_done(1'b0, "done for count_zero=0");
        @(posedge clk);
        count_zero = 1;
        @(posedge clk);
        check_done(1'b1, "done for count_zero=1");
        $finish;
    end
endmodule
