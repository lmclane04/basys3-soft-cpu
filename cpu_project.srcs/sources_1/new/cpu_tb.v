module cpu_tb;
    reg clk = 0;
    reg rst = 1;
    wire [7:0] out_led;

    cpu uut (
        .clk(clk),
        .rst(rst),
        .out_led(out_led)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Reset pulse
        #10 rst = 0;

        // Run for enough cycles to test branching/jumping
        #200;

        // Display the LED output
        $display("LED output: %b", out_led);

        // Optionally, add more checks here

        $finish;
    end
endmodule 