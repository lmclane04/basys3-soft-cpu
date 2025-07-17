/*
Simple-to-use UART for hobbyist projects

This is a simple UART for use in an FPGA as a debug engine. Requires a 50MHz
input clock that gets divided into clock enables for a 16x oversampling receiver
clock enable and 115200 baud transmission clock enable.

Icarus verilog testbench verifies that each byte can be sent correctly, but
does not do anything with spacing between bytes.

Author: Jamie Iles
Copyright: 2014
License: GPLv2
*/

module uart(
	input clk_50mhz,
	input rx,

	input tx_start,
	input [7:0] tx_data,
	output tx_busy,

	output rx_strobe,
	output [7:0] rx_data,

	output tx);

	wire tick_16x_baud;
	wire tick_baud;

	baud_rate_gen baud_rate_gen(
		.clk(clk_50mhz),
		.tick_16x_baud(tick_16x_baud),
		.tick_baud(tick_baud));

	transmitter transmitter(
		.clk(clk_50mhz),
		.tick_baud(tick_baud),
		.start(tx_start),
		.data_in(tx_data),
		.busy(tx_busy),
		.tx(tx));

	receiver receiver(
		.clk(clk_50mhz),
		.tick_16x_baud(tick_16x_baud),
		.rx(rx),
		.strobe(rx_strobe),
		.data_out(rx_data));

endmodule 