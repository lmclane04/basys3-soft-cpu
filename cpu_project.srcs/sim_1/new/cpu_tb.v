`timescale 1ns / 1ps

module cpu_tb();
    reg clk = 0;
    reg rst = 1;
    wire [7:0] out_led;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .rst(rst),
        .out_led(out_led)
    );

    // Clock generator: 10ns period (100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Dump waveforms to cpu.vcd
        $dumpfile("cpu.vcd");
        $dumpvars(0, cpu_tb);

        // Initial reset
        #10;
        rst = 0;

        // Let the CPU run for ~20 instructions
        #200;

        $finish;
    end
endmodule