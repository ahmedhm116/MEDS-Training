module controller(
    input logic clk, rst_n, start, count_zero,
    input logic [1:0] q_bits,
    output logic sub, add, done, shift_en
);
    typedef enum logic[1:0] {
        IDLE = 2'b00,
        CHECK_BITS = 2'b01,
        SHIFT = 2'b10,
        DONE = 2'b11
    } state_t;
    state_t current_state, next_state;
    always_ff @(posedge clk) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end
    always_comb begin
        next_state = current_state;
        sub        = 1'b0;
        add        = 1'b0;
        done       = 1'b0;
        shift_en   = 1'b0;
        case (current_state)
            IDLE: begin
                if (start)
                    next_state = CHECK_BITS;
            end
            CHECK_BITS: begin
                if (q_bits == 2'b01)
                    add = 1'b1;
                else if (q_bits == 2'b10)
                    sub = 1'b1;
                shift_en = 1'b1;
                next_state = SHIFT;
            end
            SHIFT: begin
                if (count_zero)
                    next_state = DONE;
                else
                    next_state = CHECK_BITS;
            end
            DONE: begin
                done = 1'b1;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
