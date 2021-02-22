// M113 - Ten 2-input NAND gates
// Kyle Owen - 13 February 2021
// Uses three 7400s; two NAND gates are unused
// Provides logic high at 3V via two voltage dividers

module m113 (
	input A1,
	input B1,
	output C1,
	input D1,
	input E1,
	output F1,
	input H1,
	input J1,
	output K1,
	input L1,
	input M1,
	output N1,
	input P1,
	input R1,
	output S1,
	//inout T1,  // ground
	output U1, // logic high, 3V
	output V1, // logic high, 3V

	//inout A2,  // +5V
	//inout B2,  // -15V (not used)
	//inout C2,  // ground
	input D2,
	input E2,
	output F2,
	input H2,
	input J2,
	output K2,
	input L2,
	input M2,
	output N2,
	input P2,
	input R2,
	output S2,
	input T2,
	input U2,
	output V2
	);

assign C1 = !(A1 & B1);
assign F1 = !(D1 & E1);
assign K1 = !(H1 & J1);
assign N1 = !(L1 & M1);
assign S1 = !(P1 & R1);
assign F2 = !(D2 & E2);
assign K2 = !(H2 & J2);
assign N2 = !(L2 & M2);
assign S2 = !(P2 & R2);
assign V2 = !(T2 & U2);
assign U1 = 1'b1;
assign V1 = 1'b1;

//assign A2 = 1'b1;
//assign B2 = 1'bz;
//assign C2 = 1'b0;
//assign T1 = 1'b0;

endmodule
