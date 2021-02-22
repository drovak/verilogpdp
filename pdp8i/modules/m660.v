// M660 - Positive level driver
// Kyle Owen - 18 February 2021

module m660 (
	//A2,  // +5V
	B2,
	//C2,  // ground
	D2,
	E2,
	F2,
	H2,
	J2,
	K2,
	L2,
	M2,
	N2,
	P2,
	R2,
	S2,
	T2,
	U2,
	V2
	);
// power and grounds
//inout A2, C2;

// main inputs
input H2, J2, N2, P2, U2, V2;

// main outputs
output D2, K2, S2;

// unused
/* verilator lint_off UNUSED */
input B2, E2, F2, L2, M2, R2, T2;
/* lint_on */

// power assignments
//assign A2 = 1'b1;
//assign C2 = 1'b0;

assign D2 = !(H2 & J2);
assign K2 = !(N2 & P2);
assign S2 = !(U2 & V2);

endmodule
