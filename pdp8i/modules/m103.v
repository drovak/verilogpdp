// M103 - Device Selector
// Kyle Owen - 9 March 2021

module m103 (
	output A1,
	output B1,
	output C1,
	output D1,
	output E1,
	output F1,
	input H1,
	input J1,
	output K1,
	input L1,
	input M1,
	output N1,
	//input P1,
	//input R1,
	//input S1,
	//inout T1,  // ground
	//input U1,
	output V1,

	//inout A2,  // +5V
	//inout B2,  // -15V (not used)
	//inout C2,  // ground
	input D2,
	input E2,
	input F2,
	input H2,
	input J2,
	input K2,
	input L2,
	//input M2,
	input N2,
	input P2,
	input R2,
	input S2,
	//input T2,
	input U2,
	output V2
	);

assign V1 = 1'b1;

//wire sel = !(U2 & !&{D2, E2, F2, H2, J2, K2, L2, N2});
wire sel = !(U2 & !({D2, E2, F2, H2, J2, K2, L2, N2} == 8'o377));
assign V2 = sel;

assign K1 = !(H1 & J1);
assign N1 = !(L1 & M1);

wire iop1_sel = P2 & sel;
wire iop2_sel = R2 & sel;
wire iop4_sel = S2 & sel;

assign A1 = iop1_sel;
assign C1 = iop2_sel;
assign E1 = iop4_sel;
assign B1 = !iop1_sel;
assign D1 = !iop2_sel;
assign F1 = !iop4_sel;

endmodule
