// M650 - Negative output converter
// Kyle Owen - 15 February 2021

module m650 (
	//A2,  // +5V
	//B2,  // -15V
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
// power and ground
//inout A2, B2, C2; 

// main inputs
input J2, H2, F2, M2, N2, P2, T2, U2, V2;

// main outputs
output D2, K2, S2;

// unused (for slew rate control)
/* verilator lint_off UNUSED */
input E2, L2, R2;
/* lint_on */

// power assignments
//assign A2 = 1'b1;
//assign B2 = 1'b0;
//assign C2 = 1'b0;

assign D2 = J2 & H2 & F2;
assign K2 = M2 & N2 & P2;
assign S2 = T2 & U2 & V2;

endmodule
