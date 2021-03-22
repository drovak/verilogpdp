// M633 - Negative Bus Driver
// Kyle Owen - 10 March 2021

module m633 (
	input A1,
	input B1,
	input C1,
	output D1,
	output E1,
	input F1,
	input H1,
	input J1,
	output K1,
	output L1,
	input M1,
	input N1,
	input P1,
	output R1,
	output S1,
	//inout T1,  // ground
	//input U1,
	//input V1,

	//inout A2,  // +5V
	//inout B2,  // -15V (not used)
	//inout C2,  // ground
	input D2,
	input E2,
	input F2,
	output H2,
	output J2,
	input K2,
	input L2,
	input M2,
	output N2,
	output P2,
	input R2,
	input S2,
	input T2,
	output U2,
	output V2
	);

assign D1 = A1 | C1 ? 1'bz : 1'b0;
assign E1 = B1 | C1 ? 1'bz : 1'b0;
assign K1 = F1 | J1 ? 1'bz : 1'b0;
assign L1 = H1 | J1 ? 1'bz : 1'b0;
assign R1 = M1 | P1 ? 1'bz : 1'b0;
assign S1 = N1 | P1 ? 1'bz : 1'b0;
assign H2 = D2 | F2 ? 1'bz : 1'b0;
assign J2 = E2 | F2 ? 1'bz : 1'b0;
assign N2 = K2 | M2 ? 1'bz : 1'b0;
assign P2 = L2 | M2 ? 1'bz : 1'b0;
assign U2 = R2 | T2 ? 1'bz : 1'b0;
assign V2 = S2 | T2 ? 1'bz : 1'b0;

endmodule
