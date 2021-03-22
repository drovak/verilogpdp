// SN7473 - dual JK flip-flop (one unit)
// Kyle Owen - 10 March 2021

module sn7473 (
	input mclk,
	input clk_n,
	input j,
	input k,
	input clr_n,
	output reg q,
	output reg q_n
	);

reg q_int;
reg old_clk_n;
reg old_j, old_old_j;
reg old_k, old_old_k;
reg old_clr_n;

always @(posedge mclk) begin
    old_clr_n <= clr_n;
	old_clk_n <= clk_n;
    old_j <= j;
    old_old_j <= old_j;
    old_k <= k;
    old_old_k <= old_k;

	if (!clr_n && !old_clr_n) begin
        q_int <= 1'b0;
        q <= 1'b0;
        q_n <= 1'b1;
    end else if ((clk_n && !old_clk_n) || (clk_n && clr_n && !old_clr_n)) begin
        if (old_old_j && !old_old_k) q_int <= 1'b1;
        else if (!old_old_j && old_old_k) q_int <= 1'b0;
        else if (old_old_j && old_old_k) q_int <= !q_int;
	end else if (!clk_n && old_clk_n) begin
        q <= q_int;
        q_n <= !q_int;
	end
end

endmodule
