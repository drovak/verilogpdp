// M627 - Power Amplifier
// Kyle Owen - 10 March 2021

module m627 (
	input A1,
	input B1,
	input C1,
	input D1,
	output E1,
	input F1,
	input H1,
	input J1,
	input K1,
	output L1,
	input M1,
	input N1,
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
	input F2,
	input H2,
	output J2,
	input K2,
	input L2,
	input M2,
	input N2,
	output P2,
	input R2,
	input S2,
	input T2,
	input U2,
	output V2
	);

assign E1 = !(A1 & B1 & C1 & D1);
assign L1 = !(F1 & H1 & J1 & K1);
assign S1 = !(M1 & N1 & P1 & R1);
assign J2 = !(D2 & E2 & F2 & H2);
assign P2 = !(K2 & L2 & M2 & N2);
assign V2 = !(R2 & S2 & T2 & U2);
assign U1 = 1'b1;
assign V1 = 1'b1;

endmodule
