// G888 - Manchester Reader/Writer
// Kyle Owen - 10 March 2021

module g888 (
	clk, // 100 MHz
	//A2,  // +5V
	//B2,
	//C2,  // ground
	D2,
	E2,
	//F2,
	//H2,
	J2,
	K2,
	L2,
	M2,
	N2,
	P2,
	R2,
	//S2,
	//T2,
	U2,
	V2
	);

// main inputs
input clk, N2, R2, P2, D2, E2;

// main outputs
output J2, K2, M2, L2, U2, V2;

reg [9:0] osc_counter;

assign L2 = !(N2 & R2);
assign J2 = !(N2 & R2);
assign M2 = !(P2 & R2);
assign K2 = !(P2 & R2);

assign U2 = (D2 == E2) ? osc_counter[9] : D2;
assign V2 = (D2 == E2) ? !osc_counter[9] : E2;

always @(posedge clk) begin
    osc_counter <= osc_counter + 'b1;
end

endmodule
