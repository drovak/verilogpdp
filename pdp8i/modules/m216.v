// M216 - Six flip-flops
// Kyle Owen - 13 February 2021
// Uses three 7474s

module m216 (
	input clk,
	input A1,
	input B1,
	input C1,
	input D1,
	output E1,
	output F1,
	input H1,
	input J1,
	input K1,
	output L1,
	output M1,
	input N1,
	input P1,
	input R1,
	output S1,
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
	output J2,
	input K2,
	input L2,
	input M2,
	input N2,
	output P2,
	output R2,
	input S2,
	input T2,
	input U2,
	output V2
	);

sn7474 ff0 (.mclk(clk), .clk(B1), .d(C1), .pre_n(D1), .clr_n(A1), .q(E1), .q_n(F1));
sn7474 ff1 (.mclk(clk), .clk(D2), .d(E2), .pre_n(F2), .clr_n(A1), .q(H2), .q_n(J2));
sn7474 ff2 (.mclk(clk), .clk(H1), .d(J1), .pre_n(K1), .clr_n(A1), .q(L1), .q_n(M1));
sn7474 ff3 (.mclk(clk), .clk(L2), .d(M2), .pre_n(N2), .clr_n(K2), .q(P2), .q_n(R2));
sn7474 ff4 (.mclk(clk), .clk(N1), .d(P1), .pre_n(R1), .clr_n(K2), .q(S1), .q_n(U1));
sn7474 ff5 (.mclk(clk), .clk(S2), .d(T2), .pre_n(U2), .clr_n(K2), .q(V2), .q_n(V1));

//assign A2 = 1'b1;
//assign B2 = 1'bz;
//assign C2 = 1'b0;
//assign T1 = 1'b0;

endmodule
