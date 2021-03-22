// M111 - 16 inverters
// Kyle Owen - 9 March 2021

module m111 (
	input A1,
	output B1,
	input C1,
	input D1,
	output E1,
	input F1,
	output H1,
	input J1,
	output K1,
	input L1,
	output M1,
	input N1,
	output P1,
	input R1,
	output S1,
	//inout T1,  // ground
	output U1,
	input V1,

	//inout A2,  // +5V
	//inout B2,  // -15V (not used)
	//inout C2,  // ground
	output D2,
	input E2,
	output F2,
	input H2,
	output J2,
	input K2,
	output L2,
	input M2,
	output N2,
	input P2,
	output R2,
	input S2,
	output T2,
	input U2,
	output V2
	);

assign B1 = !A1;
assign D2 = !C1;
assign E1 = !D1;
assign H1 = !F1;
assign F2 = !E2;
assign K1 = !J1;
assign J2 = !H2;
assign M1 = !L1;
assign L2 = !K2;
assign P1 = !N1;
assign N2 = !M2;
assign S1 = !R1;
assign R2 = !P2;
assign U1 = !V1;
assign T2 = !S2;
assign V2 = !U2;

endmodule
