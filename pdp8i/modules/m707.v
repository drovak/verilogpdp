// M707 - Teletype transmitter
// Kyle Owen - 21 February 2021

module m707 (
	clk,
	//AA1,
	AB1,
	//AC1,
	AD1,
	AE1,
	AF1,
	AH1,
	AJ1,
	AK1,
	AL1,
	//AM1,
	AN1,
	//AP1,
	AR1,
	AS1,
	//AT1,  // ground
	AU1,
	//AV1,
	//AA2,  // +5V
	//AB2,
	//AC2,  // ground
	AD2,
	AE2,
	AF2,
	AH2,
	AJ2,
	AK2,
	AL2,
	AM2,
	AN2,
	AP2,
	AR2,
	AS2,
	AT2,
	AU2,
	AV2,
	//BA1,
	//BB1,
	//BC1,
	//BD1,
	//BE1,
	//BF1,
	//BH1,
	BJ1,
	//BK1,
	//BL1,
	//BM1,
	BN1,
	BP1,
	//BR1,
	//BS1,
	//BT1,  // ground
	//BU1,
	//BV1,
	//BA2,  // +5V
	//BB2,
	//BC2,  // ground
	BD2,
	BE2,
	BF2,
	BH2,
	BJ2,
	BK2,
	//BL2,
	//BM2,
	BN2,
	BP2,
	BR2,
	BS2,
    flag,
    active,
    stop2,
    stop15,
    stop1,
    freq_div,
    line,
    srbit,
    enable_q
	//BT2,
	//BU2,
	//BV2
	);
output flag, active, stop2, stop15, stop1, freq_div, line, enable_q;
output [8:1] srbit;

//inout AA2, AC2, AT1, BA2, BC2, BT1; // power and grounds

output BJ2, BK2, AV2, AD2, AD1, AL1, BN1, BP1, 
       AK2, AJ1, BR2, AR1;

output BJ1; // +3V output
assign BJ1 = 1'b1;

input clk;

input AF1, AE1, AE2, AF2, AH2, AJ2, AN1, BH2,
      BD2, BF2, BP2, BS2, BE2, AU1, AT2, AS2,
	  AU2, AM2, AL2, AR2, AP2, AN2, AH1, AS1, 
	  BN2, AK1, AB1;

// unused
//input 

wire [9:1] par_in = {AN2, AP2, AR2, AL2, AM2, AU2, AS2, AT2, AU1};
wire [8:1] srbit;
/* verilator lint_off UNUSED */
wire [8:1] srbit_n;
/* lint_on */

wire io_clr_n = !BE2;
wire dev_select = !(AE2 & AE1 & AF2 & AF1 & AH2 & AJ2);
wire en_ds = !(AN1 & dev_select);
wire load = !(AS1 & en_ds);
assign AR1 = load;

wire enable_q, line, line_n, active, active_n;
assign AD2 = line;
assign AD1 = active;
assign AK2 = enable_q;

reg old_active;
reg [1:0] line_clr_n_cnt;
wire line_clr_n = (line_clr_n_cnt > 0) ? 1'b0 : 1'b1;
always @(posedge clk) begin
	old_active <= active;
	if (active && !old_active) line_clr_n_cnt <= 'b1;
	if (line_clr_n_cnt > 0) line_clr_n_cnt <= line_clr_n_cnt + 1;
end

generate
	genvar i;
	for (i = 0; i < 10; i=i+1) begin : gen
		if (i >= 1 && i < 8) begin
			sn7474 srbit_ff (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
			               .pre_n(!(par_in[i] & !load)), .d(srbit[i+1]), 
						   .q(srbit[i]), .q_n(srbit_n[i]));
		end else if (i == 0) begin
			sn7474 line_ff (.mclk(clk), .clk(freq_div), .clr_n(line_clr_n), 
			                .pre_n(active), .d(srbit[i+1]), 
						    .q(line), .q_n(line_n));
		end else if (i == 8) begin
			sn7474 srbit_ff (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
			               .pre_n(!(par_in[i] & !load)), .d(enable_q), 
						   .q(srbit[i]), .q_n(srbit_n[i]));
		end else begin // i == 9
			sn7474 enable_ff (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
			                  .pre_n(!(par_in[i] & !load)), .d(1'b0), 
						      .q(enable_q), .q_n(AL1));
		end
	end
endgenerate
/*
sn7474 srbit_ff1 (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                  .pre_n(!(par_in[1] & !load)), .d(srbit[2]), 
                  .q(srbit[1]), .q_n(srbit_n[1]));
sn7474 srbit_ff2 (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                  .pre_n(!(par_in[2] & !load)), .d(srbit[3]), 
                  .q(srbit[2]), .q_n(srbit_n[2]));
sn7474 srbit_ff3 (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                  .pre_n(!(par_in[3] & !load)), .d(srbit[4]), 
                  .q(srbit[3]), .q_n(srbit_n[3]));
sn7474 srbit_ff4 (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                  .pre_n(!(par_in[4] & !load)), .d(srbit[5]), 
                  .q(srbit[4]), .q_n(srbit_n[4]));
sn7474 srbit_ff5 (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                  .pre_n(!(par_in[5] & !load)), .d(srbit[6]), 
                  .q(srbit[5]), .q_n(srbit_n[5]));
sn7474 srbit_ff6 (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                  .pre_n(!(par_in[6] & !load)), .d(srbit[7]), 
                  .q(srbit[6]), .q_n(srbit_n[6]));
sn7474 srbit_ff7 (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                  .pre_n(!(par_in[7] & !load)), .d(srbit[8]), 
                  .q(srbit[7]), .q_n(srbit_n[7]));
sn7474 line_ff (.mclk(clk), .clk(freq_div), .clr_n(line_clr_n), 
                .pre_n(active), .d(srbit[1]), 
                .q(line), .q_n(line_n));
sn7474 srbit_ff (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                 .pre_n(!(par_in[8] & !load)), .d(enable_q), 
                 .q(srbit[8]), .q_n(srbit_n[8]));
sn7474 enable_ff (.mclk(clk), .clk(freq_div), .clr_n(io_clr_n), 
                  .pre_n(!(par_in[9] & !load)), .d(1'b0), 
                  .q(enable_q), .q_n(AL1));
*/

wire freq_div, freq_div_n;
sn7474 freq_div_ff (.mclk(clk), .clk(BP2), .clr_n(1'b1), .pre_n(io_clr_n),
                    .d(!(freq_div & active)), .q(freq_div), .q_n(freq_div_n));
wire stop1, stop1_n;
sn7474 stop1_ff (.mclk(clk), .clk(BP2), .clr_n(1'b1), .pre_n(freq_div),
                    .d(!(active_n & BS2)), .q(stop1), .q_n(stop1_n));
wire stop15, stop15_n;
sn7474 stop15_ff (.mclk(clk), .clk(BP2), .clr_n(1'b1), .pre_n(freq_div),
                    .d(stop1), .q(stop15), .q_n(stop15_n));
wire stop2, stop2_n;
sn7474 stop2_ff (.mclk(clk), .clk(BP2), .clr_n(1'b1), .pre_n(freq_div),
                    .d(stop15), .q(stop2), .q_n(stop2_n));
assign BN1 = stop2_n;
assign BP1 = stop15_n;
assign BR2 = stop1_n;

assign AJ1 = srbit[6];
wire active_d = !(!(BN2 & AK1) & !(active & !(freq_div_n & !flag_d)));
sn7474 active_ff (.mclk(clk), .clk(BP2), .clr_n(io_clr_n), .pre_n(1'b1),
                  .d(active_d), .q(active), .q_n(active_n));

wire flag, flag_n;
wire flag_clr_n = BF2 & !(BD2 & en_ds) & io_clr_n;
wire flag_d = !(&srbit_n[8:2] & AH1);
sn7474 flag_ff (.mclk(clk), .clk(freq_div), .pre_n(flag_clr_n), .clr_n(1'b1),
                .d(flag_d), .q(flag_n), .q_n(flag));
assign BK2 = flag_n;
assign BJ2 = !(flag & en_ds & BH2);

assign AV2 = !(AB1 & line);

//assign AA2 = 1'b1;
//assign AC2 = 1'b0;
//assign AT1 = 1'b0;
//assign BA2 = 1'b1;
//assign BC2 = 1'b0;
//assign BT1 = 1'b0;

endmodule
