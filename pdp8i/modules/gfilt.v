// Glitch filter
// Kyle Owen - 25 March 2021
// 
// Requires last FILTER_COUNT samples to be stable before
// filt output is updated. Also outputs a single clock width
// pulse for detecting positive and negative edges of the filtered
// signal.

module gfilt
    #(parameter FILTER_COUNT = 4) (
    input clk,
    input rst,
    input in,
    output reg pedge,
    output reg nedge,
    output reg filt
);

/* verilator lint_off WIDTH */
reg [2:0] count;

always @(posedge clk) begin
    if (rst) begin
        pedge <= 1'b0;
        nedge <= 1'b0;
        filt <= 1'b0;
        count <= 0;
    end else begin
        if (in) begin
            if (count <= FILTER_COUNT - 1) begin
                count <= count + 1;
                if (count == FILTER_COUNT - 1) begin
                    if (!filt) pedge <= 1'b1;
                    filt <= 1'b1;
                end
            end else begin
                pedge <= 1'b0;
            end
        end else begin
            if (count >= 1) begin
                count <= count - 1;
                if (count == 1) begin
                    if (filt) nedge <= 1'b1;
                    filt <= 1'b0;
                end
            end else begin
                nedge <= 1'b0;
            end
        end
    end
end
/* lint_on */

endmodule
