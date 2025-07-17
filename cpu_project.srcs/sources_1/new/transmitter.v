/*
Transmits a byte of serial data.

A start bit is sent, then the 8 data bits (LSB first), then a stop bit. The
start bit is low, the stop bit is high.

A new transmission can be started by pulsing the `start` input for a single
cycle. The `data_in` must be valid at this point. After this, `busy` will be
asserted until the transmission is complete.

The `tick_baud` input should be a clock enable that is asserted to send each
bit.
*/

module transmitter(
	input clk,
	input tick_baud,

	input start,
	input [7:0] data_in,
	output reg busy,
	output reg tx);

	reg [3:0] bit_count;
	reg [7:0] data;

	initial begin
		tx = 1;
		busy = 0;
		bit_count = 0;
		data = 0;
	end

	always @(posedge clk) begin
		if (start) begin
			data <= data_in;
			busy <= 1;
			tx <= 0; // Start bit
			bit_count <= 10;
		end

		if (tick_baud && bit_count > 0) begin
			bit_count <= bit_count - 1;

			case (bit_count)
			1: tx <= 1; // Stop bit
			2: tx <= data[7];
			3: tx <= data[6];
			4: tx <= data[5];
			5: tx <= data[4];
			6: tx <= data[3];
			7: tx <= data[2];
			8: tx <= data[1];
			9: tx <= data[0];
			endcase

			if (bit_count == 1) begin
				busy <= 0;
			end
		end
	end

endmodule 