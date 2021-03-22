// M602 - Pulse Amplifier
// Kyle Owen - 10 March 2021

module m602 (
	clk, // 100 MHz
	//A2,  // +5V
	//B2,
	//C2,  // ground
	//D2,
	//E2,
	F2,
	H2,
	J2,
	K2,
	L2,
	M2,
	N2,
	P2
	//R2,
	//S2,
	//T2,
	//U2,
	//V2
	);
// power and ground
//inout A2, C2; 

// main inputs
input clk, J2, K2, H2, P2, N2, M2;

// main outputs
output F2, L2;

wire en1 = !(H2 & J2 & K2);
wire en2 = !(P2 & N2 & M2);

reg old_en1, old_en2;
// delay counters for pulse duration
reg [3:0] pulse_delay1;
reg [3:0] pulse_delay2;

// output a pulse while the delay counter is greater than zero
assign F2 = (pulse_delay1 > 0) ? 1'b0 : 1'b1;
assign L2 = (pulse_delay2 > 0) ? 1'b0 : 1'b1;

always @(posedge clk) begin
    old_en1 <= en1;
    old_en2 <= en2;

	if (pulse_delay1 > 0) begin
		if (pulse_delay1 < 'd9) pulse_delay1 <= pulse_delay1 + 'b1;
		else pulse_delay1 <= 0;
	end else if (!old_en1 && en1) pulse_delay1 <= 'b1;

	if (pulse_delay2 > 0) begin
		if (pulse_delay2 < 'd9) pulse_delay2 <= pulse_delay2 + 'b1;
		else pulse_delay2 <= 0;
	end else if (!old_en2 && en2) pulse_delay2 <= 'b1;
end
endmodule
