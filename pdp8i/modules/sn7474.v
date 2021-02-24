// SN7474 - dual D flip-flop
// Kyle Owen - 19 February 2021

module sn7474 (
	input mclk,
	input clk,
	input d,
	input pre_n,
	input clr_n,
	output reg q,
	output reg q_n
	);

reg old_clk;
reg old_d;

always @(posedge mclk) begin
	old_clk <= clk;
    old_d <= d;

	if (!pre_n && !clr_n) begin
		q <= 1'b1;
		q_n <= 1'b1;
	end else if (!pre_n) begin
		q <= 1'b1;
		q_n <= 1'b0;
	end else if (!clr_n) begin
		q <= 1'b0;
		q_n <= 1'b1;
	end else if (clk && !old_clk) begin
		q <= old_d;
		q_n <= !old_d;
	end
end
/*
always @(negedge pre_n or negedge clr_n or posedge clk) begin
	if (!pre_n && !clr_n) begin
		q <= 1'b1;
		q_n <= 1'b1;
	end else if (!pre_n) begin
		q <= 1'b1;
		q_n <= 1'b0;
	end else if (!clr_n) begin
		q <= 1'b0;
		q_n <= 1'b1;
	end else begin
		q <= d;
		q_n <= !d;
	end
end
*/

///* verilator lint_off UNOPTFLAT */
//wire int_q, int_q_n, pre_l, clr_l, clk_l, d_l;
//assign q = int_q;
//assign q_n = int_q_n;
//
//assign pre_l = !(pre_n &   d_l & clr_l);
//assign clr_l = !(pre_l & clr_n &   clk);
//assign clk_l = !(clr_l &   clk &   d_l);
//assign   d_l = !(clk_l & clr_n &     d);
//assign int_q = !(pre_l & clr_l & int_q_n);
//assign int_q_n = !(int_q & clr_n & clk_l);
///* lint_on */

endmodule
