// M101 - Bus Data Interface
// Kyle Owen - 9 March 2021

module m101 (
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
	//input D2,
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

assign B1 = !(C1 & A1);
assign E1 = !(C1 & D1);
assign H1 = !(C1 & F1);
assign K1 = !(C1 & J1);
assign M1 = !(C1 & L1);
assign P1 = !(C1 & N1);
assign S1 = !(C1 & R1);
assign U1 = !(C1 & V1);
assign F2 = !(C1 & E2);
assign J2 = !(C1 & H2);
assign L2 = !(C1 & K2);
assign N2 = !(C1 & M2);
assign R2 = !(C1 & P2);
assign T2 = !(C1 & S2);
assign V2 = !(C1 & U2);

endmodule
