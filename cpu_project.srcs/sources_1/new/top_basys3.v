module top_basys3(
    input clk,                // 100 MHz clock
    input rst,                // Reset button
    input [7:0] sw,           // Basys3 switches
    output [7:0] led,         // Basys3 LEDs
    output [6:0] seg,         // 7-segment cathodes
    output [3:0] an           // 7-segment anodes
);
    wire [7:0] led_out;
    wire [7:0] display_out;

    // Instantiate CPU
    cpu cpu_inst(
        .clk(clk),
        .rst(rst),
        .switches(sw),
        .led_out(led_out),
        .display_out(display_out)
    );

    assign led = led_out;

    // Use only lower 8 bits for display (pad to 16 bits)
    sevenseg_driver sseg_inst(
        .clk(clk),
        .rst(rst),
        .value({8'b0, display_out}),
        .an(an),
        .seg(seg)
    );
endmodule 