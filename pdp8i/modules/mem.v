// 32k by 12 memory
// Kyle Owen - 15 February 2021

module mem (
	input clk, // 100 MHz
	input mem_start,
	output mem_done_n,
	output strobe_n,
	input wire [14:0] addr,
	input wire [11:0] data_in,
	output reg [11:0] data_out
    //output [11:0] dt_ca,
    //output [11:0] dt_wc
);

reg [11:0] ram [0:32767] /* verilator public_flat */;
//assign dt_wc = ram[15'o7754];
//assign dt_ca = ram[15'o7755];

reg prev_mem_start;

// timer for 1.5 microseconds
reg [7:0] timer;

wire strobe = ((timer >= 8'd50) && (timer < 8'd60)) ? 1'b1 : 1'b0;
assign strobe_n = !strobe;
//wire write = ((timer >= 8'd80) && (timer < 8'd149)) ? 1'b1 : 1'b0;
wire write = (timer == 8'd80) ? 1'b1 : 1'b0;
assign mem_done_n = (timer >= 8'd149) ? 1'b0 : 1'b1;

always @(posedge clk) begin

	prev_mem_start <= mem_start;
	if (mem_start && !prev_mem_start) begin
		timer <= 1;
	end
	else if ((timer > 0) && (timer < 8'd160)) timer <= timer + 1;

	if (write) ram[addr] <= data_in;
	if (timer == 8'd30) data_out <= ram[addr];
end
endmodule
