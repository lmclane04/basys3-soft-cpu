module top_basys3(
    input clk,                // 100 MHz clock
    input rst,                // Reset button
    input [7:0] sw,           // Basys3 switches
    output [7:0] led,         // Basys3 LEDs
    output [6:0] seg,         // 7-segment cathodes
    output [3:0] an,          // 7-segment anodes
    output uart_tx,
    input uart_rx,
    input btnU
);

    // wire [7:0] led_out;
    // wire [7:0] display_out;

    // Instantiate CPU
    cpu cpu_inst(
        .clk(clk),
        .rst(rst),
        .switches(sw),
        .led_out(),
        .display_out()
    );

    // The CPU is no longer connected to the LEDs and seven-segment display
    // assign led = led_out;
    
    wire tx_start;
    wire [7:0] tx_data;
    wire tx_busy;
    wire rx_strobe;
    wire [7:0] rx_data;
    
    assign tx_start = btnU;
    assign tx_data = sw;
    assign led = rx_data;

    uart uart_inst (
        .clk_50mhz(clk), // Note: The UART is designed for 50MHz, but we're using 100MHz.
                         // This will make the baud rate twice as fast. We'll adjust on the computer side.
        .rx(uart_rx),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_busy(tx_busy),
        .rx_strobe(rx_strobe),
        .rx_data(rx_data),
        .tx(uart_tx)
    );


    // Use only lower 8 bits for display (pad to 16 bits)
    /*sevenseg_driver sseg_inst(
        .clk(clk),
        .rst(rst),
        .value({8'b0, display_out}),
        .an(an),
        .seg(seg)
    );*/
endmodule 