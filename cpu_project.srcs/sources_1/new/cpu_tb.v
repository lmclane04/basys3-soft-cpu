module cpu_tb;
    reg clk = 0;
    reg rst = 1;
    reg [7:0] switches = 8'b10101010; // Example switch value
    wire [7:0] led_out;
    wire [7:0] display_out;

    cpu uut (
        .clk(clk),
        .rst(rst),
        .switches(switches),
        .led_out(led_out),
        .display_out(display_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Reset pulse
        #10 rst = 0;

        // Wait for LOAD/STORE to complete
        #50;
        $display("[t=%0t] LED output after LOAD/STORE: %b", $time, led_out);
        $display("[t=%0t] Display output after LOAD/STORE: %b", $time, display_out);

        // Change switches and observe update
        switches = 8'b11001100;
        #50;
        $display("[t=%0t] LED output after switches change: %b", $time, led_out);
        $display("[t=%0t] Display output after switches change: %b", $time, display_out);

        $finish;
    end
endmodule 