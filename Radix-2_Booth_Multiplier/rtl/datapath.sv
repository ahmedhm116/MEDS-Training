module datapath(
    input  logic clk, rst_n, sub, add, shift_en,
    input  logic signed [7:0] M, Q,
    output logic [1:0] q_bits,
    output logic count_zero,
    output logic signed [15:0] product
);
    logic signed [8:0] AC, AC_next;
    logic signed [7:0] Q_reg;
    logic q;
    logic [3:0] count;
    logic signed [17:0] combined;
    logic signed [17:0] shifted;

    always_comb begin
        if (sub)
            AC_next = AC - M;
        else if (add)
            AC_next = AC + M;
        else
            AC_next = AC;
    end

    assign combined   = {AC_next, Q_reg, q};
    assign shifted    = combined >>> 1;
    assign count_zero = (count == 4'b0000);
    assign q_bits      = {Q_reg[0], q};

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            AC    <= 9'b0;
            Q_reg <= Q;
            q     <= 1'b0;
            count <= 4'b1000;
        end else if (shift_en) begin
            AC     <= shifted[17:9];
            Q_reg  <= shifted[8:1];
            q      <= shifted[0];
            count  <= count - 1'b1;
        end
        if (count_zero)
            product <= {AC[7:0], Q_reg};
    end
endmodule
