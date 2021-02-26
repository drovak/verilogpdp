// M452 - Variable clock
// Kyle Owen - 15 February 2021
// Used for 8x and 2x baud rate generation

module m452 #(
	parameter BAUD=1562500) (
	clk, // 100 MHz
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
// power and ground
//inout A2, C2; 

// main inputs
input clk, P2;

// main outputs
output R2, J2, H2, N2, M2, K2, L2;

// unused
/* verilator lint_off UNUSED */
input T2, B2, D2, E2, F2, S2, U2, V2;
/* lint_on */

// power assignments
//assign A2 = 1'b1;
//assign C2 = 1'b0;

// what do we need to count to in order to generate 16x the baud rate?
localparam max_count = $rtoi($floor((100e6 / (16 * BAUD)) + 0.5) - 1);

// baud rate counter
reg [$clog2(max_count):0] count;

// baud rate divider
reg [2:0] div;
assign J2 = div[0];
assign H2 = !div[0];
assign N2 = div[1];
assign M2 = !div[1];
assign K2 = div[2];
assign L2 = div[2];

// for falling edge detection of delayed signal
reg prev;

// delay element for pulse duration
reg [3:0] pulse_delay;

// output a pulse while the delay counter is greater than zero
assign R2 = (pulse_delay > 0) ? 1'b1 : 1'b0;

always @(posedge clk) begin
	// falling edge detector
	prev <= P2;

	// start delay counters when falling edge is encountered
	if (!P2 && prev) pulse_delay <= 1;

	// count only if greater than zero; reset after 100 ns
	if (pulse_delay > 0) begin
		if (pulse_delay < 9) pulse_delay <= pulse_delay + 1;
		else pulse_delay <= 0;
	end

	// free-running counter; reset after max_count
	count <= count + 1;
	/* verilator lint_off WIDTH */
	if (count >= max_count) begin
	/* lint_on */
		count <= 0;
		div <= div + 1;
	end
end
endmodule
