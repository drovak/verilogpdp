// M162 - Parity detector
// Kyle Owen - 13 February 2021
// Uses 7420 and 7430

/* verilator lint_off UNUSED */
module m162 (
	input A1,
	input B1,
	input C1,
	input D1,
	input E1,
	input F1,
	input H1,
	input J1,
	output K1,
	output L1,
	input M1,
	input N1,
	input P1,
	input R1,
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
	input T2,
	output U2,
	output V2
	);
/* lint_on */

wire par1, par2;

assign par1 = ((E1 & B1 & C1 & D1) |
               (E1 & B1 & H1 & J1) |
               (E1 & F1 & C1 & J1) |
               (E1 & F1 & H1 & D1) |
               (A1 & F1 & H1 & J1) |
               (A1 & F1 & C1 & D1) |
               (A1 & B1 & H1 & D1) |
               (A1 & B1 & C1 & J1));
assign K1 = par1;
assign L1 = !par1;

assign par2 = ((P2 & L2 & M2 & N2) |
               (P2 & L2 & S2 & T2) |
               (P2 & R2 & M2 & T2) |
               (P2 & R2 & S2 & N2) |
               (K2 & R2 & S2 & T2) |
               (K2 & R2 & M2 & N2) |
               (K2 & L2 & S2 & N2) |
               (K2 & L2 & M2 & T2));
assign U2 = par2;
assign V2 = !par2;

//assign A2 = 1'b1;
//assign B2 = 1'bz;
//assign C2 = 1'b0;
//assign T1 = 1'b0;

endmodule
