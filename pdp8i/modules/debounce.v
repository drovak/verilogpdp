module debounce
    #(parameter CYCLES=5000000) (
    input clk,
    input rst,
    input in,
    output reg out
);

integer count;

always @(posedge clk) begin
    if (in) begin
        if (count < CYCLES)
            count <= count + 1;
        else
            count <= CYCLES;
    end else begin
        if (count > 0)
            count <= count - 1;
    end

    if (count == 0)
        out <= 1'b0;
    else if (count >= CYCLES)
        out <= 1'b1;

    if (rst) begin
        out <= 1'b0;
        count <= 0;
    end
end

endmodule
