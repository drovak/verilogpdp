/*
 * JR-IDE Project
 * - (c) 2017 Alan Hightower
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

`define state_IDLE    3'b000
`define state_START   3'b001
`define state_SHIFT   3'b010
`define state_STOP    3'b011
`define state_STOP2   3'b100
`define state_STOP3   3'b101
`define state_WRITE   3'b110

/* verilator lint_off DECLFILENAME */
/* verilator lint_off WIDTH */
/* verilator lint_off CASEINCOMPLETE */
module uart_rx #(
	parameter CLK_FREQ = 25000000,
	parameter BAUD_RATE = 115200
)
(
	input        clk,

	input        pad,

	output [7:0] data,
	output       strobe
);

	localparam DIVISOR = CLK_FREQ / BAUD_RATE;

	reg  [7:0] rsr     = 8'h00;        // Receiver Shift Register
	reg  [3:0] bitcnt  = 4'h0;         // # of bits shifted in so far
	reg  [2:0] state   = `state_IDLE;  // Current FSM state
	reg [15:0] counter = 16'h0000;     // Bit hold counter - from divisor

	assign data = rsr;

	// Buffered & delayed input for start bit edge detection

	reg pad_d0 = 1'b1;
	reg pad_d1 = 1'b1;

	always @(posedge clk)
	begin 
		pad_d0 <= pad;
		pad_d1 <= pad_d0;
	end 

	always @(posedge clk)
	begin 

		case (state)
		`state_IDLE:
		begin
			if (~pad_d0 & pad_d1) // falling edge
				state <= `state_START;

			counter <= DIVISOR - 1; 
		end  

		`state_START:
		begin
			if (counter == (DIVISOR/2))
			begin
				if (pad_d0)
					state <= `state_IDLE;
			end

			rsr    <= 0;
			bitcnt <= 4'h0;

			if (counter)
				counter <= counter - 1;
			else
			begin
				state   <= `state_SHIFT;
				counter <= DIVISOR - 1;
			end
		end            

		`state_SHIFT:
		begin
			if (counter == (DIVISOR/2))
			begin
				rsr    <= { pad_d0, rsr[7:1] };
				bitcnt <= bitcnt + 1; 
			end

			if (counter)
				counter <= counter - 1;
			else
			begin
				if (bitcnt == 8)
					state <= `state_STOP;
					counter <= DIVISOR - 1;
			end
		end

		`state_STOP:
		begin  
			if (counter == (DIVISOR/2))
			begin
				if (~pad_d0) // Stop bit invalid - ignore byte
					state <= `state_IDLE;
				else
					state <= `state_WRITE;
			end
			else
				counter <= counter - 1;
		end

		`state_WRITE:
			state <= `state_IDLE;

		endcase
	end

	assign strobe = (state == `state_WRITE);

endmodule


module uart_tx #(
	parameter CLK_FREQ = 25000000,
	parameter BAUD_RATE = 115200
)
(
	input       clk,

	input [7:0] data,
	input       strobe,

	output      pad,
	output      ready
);

	localparam DIVISOR = CLK_FREQ / BAUD_RATE;

	reg        pad_d0  = 1'b1;         // Current presentation bit
	reg  [7:0] tsr     = 8'h00;        // Transmit Shift Register
	reg  [3:0] bitcnt  = 4'h0;         // # of bits shifted out so far
	reg  [2:0] state   = `state_IDLE;  // Current FSM state
	reg [15:0] counter = 16'h0000;     // Bit hold counter - from divisor

	always @(posedge clk)
	begin

		case (state)
		`state_IDLE:
		begin

			pad_d0 <= 1'b1;

			if (strobe)
			begin
				state   <= `state_START;
				counter <= DIVISOR - 1;
				tsr     <= data;
				bitcnt  <= 0;
			end
		end


		`state_START:
		begin

			pad_d0 <= 1'b0;

			if (counter)
				counter <= counter - 1;
			else
			begin
				counter <= DIVISOR - 1;
				state   <= `state_SHIFT;
			end
		end

		`state_SHIFT:
		begin

			pad_d0 <= tsr[0];

			if (counter)
				counter <= counter - 1;
			else
			begin
				counter <= DIVISOR - 1;
				tsr     <= { 1'b0, tsr[7:1] };
				bitcnt  <= bitcnt + 1;

				if (bitcnt == 7)
					state <= `state_STOP;
			end
		end

		`state_STOP:
		begin

			pad_d0 <= 1'b1;

			if (counter)
				counter <= counter - 1;
			else
            begin
				state   <= `state_STOP2;
				counter <= DIVISOR - 1;
            end
		end

		`state_STOP2:
		begin

			if (counter)
				counter <= counter - 1;
			else
            begin
				state   <= `state_STOP3;
				counter <= DIVISOR - 1;
            end
		end

		`state_STOP3:
		begin

			if (counter)
				counter <= counter - 1;
			else
				state   <= `state_IDLE;
		end
		endcase
	end

	assign pad = pad_d0;
	assign ready = (state == `state_IDLE);

endmodule
/* lint_on */
