// M161 - Binary to Octal/Decimal Decoder
// Kyle Owen - 9 March 2021

module m161 (
	//output A1,
	//output B1,
	//output C1,
	output D1,
	output E1,
	output F1,
	output H1,
	output J1,
	//output K1,
	output L1,
	output M1,
	output N1,
	output P1,
	output R1,
	input S1,
	//inout T1,  // ground
	input U1,
	input V1,

	//inout A2,  // +5V
	//inout B2,  // -15V (not used)
	//inout C2,  // ground
	output D2,
	output E2,
	output F2,
	output H2,
	output J2,
	//output K2,
	output L2,
	output M2,
	output N2,
	output P2,
	output R2,
	input S2,
	input T2,
	input U2,
	input V2
	);

wire [3:0] val = {U1, V2, U2, V1};
wire en = T2 & S1 & S2;
wire out0 = en & (val == 4'h0);
wire out1 = en & (val == 4'h1);
wire out2 = en & (val == 4'h2);
wire out3 = en & (val == 4'h3);
wire out4 = en & (val == 4'h4);
wire out5 = en & (val == 4'h5);
wire out6 = en & (val == 4'h6);
wire out7 = en & (val == 4'h7);
wire out8 = en & U1 & !V1;
wire out9 = en & U1 & V1;

assign D2 = out0;
assign D1 = !out0;
assign E2 = out1;
assign E1 = !out1;
assign J2 = out2;
assign J1 = !out2;
assign N2 = out3;
assign N1 = !out3;
assign F2 = out4;
assign F1 = !out4;
assign M2 = out5;
assign M1 = !out5;
assign H2 = out6;
assign H1 = !out6;
assign L2 = out7;
assign L1 = !out7;
assign P2 = out8;
assign P1 = !out8;
assign R2 = out9;
assign R1 = !out9;

endmodule
