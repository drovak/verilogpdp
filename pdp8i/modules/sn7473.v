// SN7473 - dual JK flip-flop (one unit)
// Kyle Owen - 10 March 2021

module sn7473 (
	input mclk,
    input mrst,
	input clk_n,
	input j,
	input k,
	input clr_n,
	output reg q,
	output reg q_n
	);

reg q_int;

wire clk_n_pedge, clk_n_nedge, clk_n_f;
wire clr_n_pedge, clr_n_f;
wire j_f, k_f;

/* verilator lint_off PINMISSING */
gfilt filt_clk_n (.clk(mclk), .rst(mrst), .in(clk_n), .pedge(clk_n_pedge), .nedge(clk_n_nedge), .filt(clk_n_f));
gfilt filt_clr_n (.clk(mclk), .rst(mrst), .in(clr_n), .pedge(clr_n_pedge), .filt(clr_n_f));
gfilt filt_j (.clk(mclk), .rst(mrst), .in(j), .filt(j_f));
gfilt filt_k (.clk(mclk), .rst(mrst), .in(k), .filt(k_f));
/* lint_on */

always @(posedge mclk) begin
	if (!clr_n_f) begin
        q_int <= 1'b0;
        q <= 1'b0;
        q_n <= 1'b1;
    end else if (clk_n_pedge || (clk_n_f && clr_n_pedge)) begin
        if (j_f && !k_f) q_int <= 1'b1;
        else if (!j_f && k_f) q_int <= 1'b0;
        else if (j_f && k_f) q_int <= !q_int;
	end else if (clk_n_nedge) begin
        q <= q_int;
        q_n <= !q_int;
	end
end

/*
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
*/

endmodule
