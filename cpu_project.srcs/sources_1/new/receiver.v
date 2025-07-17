/*
Receives a byte of serial data.

The start bit is used to synchronise the receiver, then the 8 data bits are
sampled from the middle of the bit time. The stop bit is not checked.

The `rx_strobe` output is pulsed for a single cycle when a byte has been
received. `rx_data` is valid at this point.

The `tick_16x_baud` input should be a clock enable that is asserted at 16 times
the baud rate.
*/

module receiver(
	input clk,
	input tick_16x_baud,

	input rx,
	output reg strobe,
	output reg [7:0] data_out);

	parameter IDLE = 0;
	parameter START = 1;
	parameter DATA = 2;
	parameter STOP = 3;

	reg [1:0] state;
	reg [3:0] bit_count;
	reg [2:0] data_count;

	initial begin
		state = IDLE;
		strobe = 0;
		data_out = 0;
		bit_count = 0;
		data_count = 0;
	end

	always @(posedge clk) begin
		strobe <= 0;

		if (tick_16x_baud) begin
			case (state)
			IDLE: begin
				if (~rx) begin
					state <= START;
					bit_count <= 0;
				end
			end

			START: begin
				bit_count <= bit_count + 1;
				if (bit_count == 7) begin
					state <= DATA;
					bit_count <= 0;
					data_count <= 0;
				end
			end

			DATA: begin
				bit_count <= bit_count + 1;
				if (bit_count == 15) begin
					bit_count <= 0;
					data_out[data_count] <= rx;

					if (data_count == 7) begin
						state <= STOP;
					end else begin
						data_count <= data_count + 1;
					end
				end
			end

			STOP: begin
				bit_count <= bit_count + 1;
				if (bit_count == 15) begin
					strobe <= 1;
					state <= IDLE;
				end
			end

			endcase
		end
	end

endmodule 