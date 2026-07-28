module tb;
    logic clk = 0, rst_n, start;
    logic signed [7:0] M, Q;
    logic signed [15:0] product;
    logic done;
    always #5 clk = ~clk;

    booth_multiplier u1 (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .M(M),
        .Q(Q),
        .product(product),
        .done(done)
    );

    task automatic check(input logic signed [15:0] actual, expected, input logic signed [7:0] M_in, Q_in);
        if (expected !== actual)
            $display("[FAIL] M=%0d, Q=%0d, expected=%0d, actual=%0d", M_in, Q_in, expected, actual);
        else
            $display("[PASS] M=%0d, Q=%0d, Product=%0d", M_in, Q_in, actual);
    endtask

    function automatic logic signed [15:0] expected_fn(input logic signed [7:0] M, Q);
        return M * Q;
    endfunction

    task automatic run_test(input logic signed [7:0] M_in, Q_in);
        rst_n = 0;
        start = 0;
        M = M_in;
        Q = Q_in;
        #10;
        @(posedge clk);
        rst_n = 1;
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;
        wait (done);
        #1;
        check(product, expected_fn(M_in, Q_in), M_in, Q_in);
    endtask

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

      for (int s1 = -10; s1 <= 10; s1++)
        for (int s2 = -2; s2 <= 10; s2++)
                run_test(s1[7:0], s2[7:0]);

        $finish;
    end
endmodule
