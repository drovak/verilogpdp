// M115 - Eight 3-input NAND gates
// Kyle Owen - 13 February 2021
// Uses three 7410s; one NAND gate is unused

module m115 (
	input A1,
	input B1,
	input C1,
	output D1,
	input E1,
	input F1,
	input H1,
	output J1,
	input K1,
	input L1,
	input M1,
	output N1,
	input P1,
	input R1,
	input S1,
	//inout T1,  // ground
	output U1,
	output V1,

	//inout A2,  // +5V
	//inout B2,  // -15V (not used)
	//inout C2,  // ground
	input D2,
	input E2,
	input F2,
	output H2,
	input J2,
	input K2,
	input L2,
	output M2,
	input N2,
	input P2,
	input R2,
	output S2,
	input T2,
	input U2,
	input V2
	);

assign D1 = !(A1 & B1 & C1);
assign J1 = !(E1 & F1 & H1);
assign N1 = !(K1 & L1 & M1);
assign U1 = !(P1 & R1 & S1);
assign V1 = !(T2 & U2 & V2);
assign H2 = !(D2 & E2 & F2);
assign M2 = !(J2 & K2 & L2);
assign S2 = !(N2 & P2 & R2);

//assign A2 = 1'b1;
//assign B2 = 1'bz;
//assign C2 = 1'b0;
//assign T1 = 1'b0;

endmodule
