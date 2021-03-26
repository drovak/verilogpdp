// M207 - Six JK flip-flops
// Kyle Owen - 10 March 2021

module m207 (
	input clk,
    input rst,
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

sn7473 ff0 (.mclk(clk), .mrst(rst), .clk_n(B1), .k(C1), .j(D1), .clr_n(A1), .q(E1), .q_n(F1));
sn7473 ff1 (.mclk(clk), .mrst(rst), .clk_n(D2), .k(E2), .j(F2), .clr_n(A1), .q(H2), .q_n(J2));
sn7473 ff2 (.mclk(clk), .mrst(rst), .clk_n(H1), .k(J1), .j(K1), .clr_n(A1), .q(L1), .q_n(M1));
sn7473 ff3 (.mclk(clk), .mrst(rst), .clk_n(N1), .k(P1), .j(R1), .clr_n(K2), .q(S1), .q_n(U1));
sn7473 ff4 (.mclk(clk), .mrst(rst), .clk_n(S2), .k(T2), .j(U2), .clr_n(K2), .q(V2), .q_n(V1));
sn7473 ff5 (.mclk(clk), .mrst(rst), .clk_n(L2), .k(M2), .j(N2), .clr_n(K2), .q(P2), .q_n(R2));

endmodule
