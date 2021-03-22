// M401 - Variable clock
// Kyle Owen - 10 March 2021

module m401 #(
	parameter FREQ=120000) (
	clk, // 100 MHz
	//A2,  // +5V
	//B2,
	//C2,  // ground
	D2,
	E2,
	//F2,
	//H2,
	J2,
	K2
	//L2,
	//M2,
	//N2,
	//P2,
	//R2,
	//S2,
	//T2,
	//U2,
	//V2
	);
// power and ground
//inout A2, C2; 

// main inputs
input clk, J2, K2;

// main outputs
output D2, E2;

wire en = !(K2 & J2);

// counter
reg [22:0] count;

// delay counter for pulse duration
reg [3:0] pulse_delay;

// output a pulse while the delay counter is greater than zero
assign D2 = (pulse_delay > 0) ? 1'b1 : 1'b0;
assign E2 = (pulse_delay > 0) ? 1'b0 : 1'b1;

localparam [22:0] MAX_COUNT = {$rtoi(100e6 / FREQ) - 1}[22:0];

always @(posedge clk) begin
	if (pulse_delay > 0) begin
		if (pulse_delay < 'd9) pulse_delay <= pulse_delay + 'b1;
		else pulse_delay <= 0;
	end

	if (count >= MAX_COUNT) begin
		count <= 0;
		pulse_delay <= 'b1;
    end else if (en) begin
        count <= count + 'b1;
	end
end
endmodule
