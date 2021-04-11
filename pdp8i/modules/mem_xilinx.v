// 32k by 12 memory, from memory generator
// Kyle Owen - 27 March 2021

module mem_xilinx (
	input clk, // 100 MHz
	input mem_start,
	output mem_done_n,
	output strobe_n,
	input wire [14:0] addr,
	input wire [11:0] data_in,
	output reg [11:0] data_out
	);

reg prev_mem_start;

// timer for 1.5 microseconds
reg [7:0] timer;

wire strobe = ((timer >= 8'd50) && (timer < 8'd60)) ? 1'b1 : 1'b0;
assign strobe_n = !strobe;
//wire write = ((timer >= 8'd82) && (timer < 8'd90)) ? 1'b1 : 1'b0;
wire write = (timer == 8'd80) ? 1'b1 : 1'b0;
assign mem_done_n = (timer >= 8'd149) ? 1'b0 : 1'b1;

//reg [11:0] data_in_reg;
//reg [14:0] addr_reg;
wire [11:0] data_out_int;

blk_mem_32k_by_12 ram (clk, write, addr, data_in, data_out_int);

always @(posedge clk) begin

	prev_mem_start <= mem_start;
	if (mem_start && !prev_mem_start) begin
		timer <= 1;
	end
	else if ((timer > 0) && (timer < 8'd160)) timer <= timer + 1;

	//if (write) ram[addr] <= data_in;
	//if (timer == 8'd30) data_out <= ram[addr];
    //if (timer == 8'd80) begin
    //    addr_reg <= addr;
    //    data_in_reg <= data_in;
    //end
	if (timer == 8'd30) data_out <= data_out_int;
end
endmodule
