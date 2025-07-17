/*
Generates baud rate clock enables.

Given a 50MHz input clock, this module will generate clock enables for 115200
baud and 16x 115200 baud.
*/

module baud_rate_gen(
	input clk,
	output reg tick_16x_baud,
	output reg tick_baud);

	reg [7:0] count_16x;
	reg [3:0] count_1x;

	parameter BAUD_115200_DIV = 27; // 50M / (115200 * 16)

	initial begin
		count_16x = 0;
		count_1x = 0;
		tick_16x_baud = 0;
		tick_baud = 0;
	end

	always @(posedge clk) begin
		tick_16x_baud <= 0;
		tick_baud <= 0;

		count_16x <= count_16x + 1;
		if (count_16x == BAUD_115200_DIV - 1) begin
			count_16x <= 0;
			tick_16x_baud <= 1;

			count_1x <= count_1x + 1;
			if (count_1x == 15) begin
				count_1x <= 0;
				tick_baud <= 1;
			end
		end
	end

endmodule 