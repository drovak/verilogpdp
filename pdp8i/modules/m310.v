// M310 - Delay line
// Kyle Owen - 15 February 2021

module m310 (
	clk, // 100 MHz
	//A1,
	//B1,
	//C1,
	//D1,
	E1,
	F1,
	H1,
	J1,
	//K1,
	//L1,
	//M1,
	//N1,
	//P1,
	//R1,
	//S1,
	//T1,  // ground
	//U1,
	//V1,
	//A2,  // +5V
	//B2,
	//C2,  // ground
	//D2,
	//E2,
	//F2,
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
//inout A2, C2, T1; 

// main inputs
input clk, H2, E1, H1;

// main outputs
output J2, K2, L2, M2, N2, V2, P2, R2, S2, T2, U2, F1, J1;

// unused
/* verilator lint_off UNUSED */
//input A1, B1, C1, D1, K1, L1, M1, N1, P1, R1, S1,
//	U1, V1, B2, D2, E2, F2;
/* lint_on */

// power assignments
//assign A2 = 1'b1;
//assign C2 = 1'b0;
//assign T1 = 1'b0;

// main delay line
reg [50:0] delay;

// for falling edge detection of input
reg prev_H1, prev_E1;

// delay elements for pulse duration
reg [3:0] H1_delay;
reg [3:0] E1_delay;

// 50 ns delay between taps
assign J2 = delay[0];
assign K2 = delay[5];
assign L2 = delay[10];
assign M2 = delay[15];
assign N2 = delay[20];
assign P2 = delay[25];
assign R2 = delay[30];
assign S2 = delay[35];
assign T2 = delay[40];
assign U2 = delay[45];
assign V2 = delay[50];

// output a pulse while the delay counters are greater than zero
assign F1 = (E1_delay > 0) ? 1'b1 : 1'b0;
assign J1 = (H1_delay > 0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
	// shift in H2 every 10 ns
	delay <= {delay[49:0], !H2};

	// falling edge detectors
	prev_E1 <= E1;
	prev_H1 <= H1;

	// start delay counters when falling edge is encountered
	if (!E1 && prev_E1) E1_delay <= 1;
	if (!H1 && prev_H1) H1_delay <= 1;

	// count only if greater than zero; reset after 100 ns
	if (E1_delay > 0) begin
		if (E1_delay < 4'd9) E1_delay <= E1_delay + 1;
		else E1_delay <= 0;
	end

	if (H1_delay > 0) begin
		if (H1_delay < 4'd9) H1_delay <= H1_delay + 1;
		else H1_delay <= 0;
	end
end
endmodule
