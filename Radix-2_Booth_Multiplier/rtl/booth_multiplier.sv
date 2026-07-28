module booth_multiplier(
    input  logic clk, rst_n, start,
    input  logic signed [7:0] M, Q,
    output logic signed [15:0] product,
    output logic done
);
    logic sub, add;
    logic [1:0] q_bits;
    logic count_zero;
    logic shift_en;

    controller ctrl (
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
    datapath dp (
        .clk(clk),
        .rst_n(rst_n),
        .sub(sub),
        .add(add),
        .shift_en(shift_en),
        .M(M),
        .Q(Q),
        .q_bits(q_bits),
        .count_zero(count_zero),
        .product(product)
    );
endmodule
