// M160 - Gate module (three AOIs)
// Kyle Owen - 13 February 2021
// Uses 7450, 7453, and 7460

module m160 (
	input A1,
	input B1,
	input C1,
	input D1,
	input E1,
	input F1,
	input H1,
	input J1,
	input K1,
	input L1,
	input M1,
	input N1,
	input P1,
	output R1,
	input S1,
	//inout T1,  // ground
	input U1,
	input V1,

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
	input M2,
	input N2,
	input P2,
	input R2,
	input S2,
	output T2,
	input U2,
	output V2
	);

assign R1 = !((A1 & B1 & C1 & D1) | (E1 & F1) | (H1 & J1) | (K1 & L1) | (M1 & N1 & P1));
assign T2 = !((D2 & E2 & F2 & H2) | (J2 & K2) | (L2 & M2) | (N2 & P2 & R2 & S2));
assign V2 = !((S1 & U1) | (V1 & U2));

//assign A2 = 1'b1;
//assign B2 = 1'bz;
//assign C2 = 1'b0;
//assign T1 = 1'b0;

endmodule
