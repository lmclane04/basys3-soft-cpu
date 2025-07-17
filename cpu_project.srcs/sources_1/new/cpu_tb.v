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

        // Wait for LOAD/STORE to complete
        #50;
        $display("[t=%0t] LED output after LOAD/STORE: %b", $time, out_led);

        // Wait more cycles to observe stability
        #100;
        $display("[t=%0t] LED output later: %b", $time, out_led);

        $finish;
    end
endmodule 