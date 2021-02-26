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
	//output q,
	//output q_n
	);

reg old_clk;
reg old_d, old_old_d;
reg old_pre_n;
reg old_clr_n;

//reg q_int, q_n_int;

/*
assign q = (old_pre_n && old_clr_n) ? q_int :
           (old_pre_n && !old_clr_n) ? 1'b0 : 1'b1;
assign q_n = (old_pre_n && old_clr_n) ? q_n_int :
             (!old_pre_n && old_clr_n) ? 1'b0 : 1'b1;
             */
             /*
assign q = (pre_n && clr_n) ? q_int :
           (pre_n && !clr_n) ? 1'b0 : 1'b1;
assign q_n = (pre_n && clr_n) ? q_n_int :
             (!pre_n && clr_n) ? 1'b0 : 1'b1;
             */


always @(posedge mclk) begin
    old_pre_n <= pre_n;
    old_clr_n <= clr_n;
	old_clk <= clk;
    old_d <= d;
    old_old_d <= old_d;

	if (!pre_n && !clr_n && !old_clr_n && !old_pre_n) begin
		q <= 1'b1;
		q_n <= 1'b1;
	end else if (!pre_n && !old_pre_n) begin
		q <= 1'b1;
		q_n <= 1'b0;
	end else if (!clr_n && !old_clr_n) begin
		q <= 1'b0;
		q_n <= 1'b1;
	end else if (clk && !old_clk) begin
		q <= old_old_d;
		q_n <= !old_old_d;
	end
    /*
	if (!pre_n && !clr_n && !old_clr_n && !old_pre_n) begin
		q_int <= 1'b1;
		q_n_int <= 1'b1;
	end else if (!pre_n && !old_pre_n) begin
		q_int <= 1'b1;
		q_n_int <= 1'b0;
	end else if (!clr_n && !old_clr_n) begin
		q_int <= 1'b0;
		q_n_int <= 1'b1;
	end else if (clk && !old_clk) begin
		q_int <= old_d;
		q_n_int <= !old_d;
	end
    */
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
