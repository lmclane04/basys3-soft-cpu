`timescale 1ns / 1ps

module top_basys3_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] sw;
    reg btnU;

    // Outputs
    wire [7:0] led;
    wire uart_tx;
    
    // Internal wire for loopback
    wire uart_rx_internal;
    
    assign uart_rx_internal = uart_tx;

    top_basys3 uut (
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .led(led),
        .an(),
        .seg(),
        .uart_tx(uart_tx),
        .uart_rx(uart_rx_internal),
        .btnU(btnU)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        sw = 0;
        btnU = 0;

        // Apply reset
        #100;
        rst = 0;
        #100;
        rst = 1;

        $display("Testbench for top_basys3 started.");
        
        // Set switches to 'A'
        sw <= "A";
        #20;

        // Simulate button press
        $display("Simulating button press to send 'A'.");
        btnU <= 1;
        #10;
        btnU <= 0;
        
        // Wait for data to be received on LEDs
        // Allow enough time for transmission and reception
        #200000;

        if (led == "A") begin
            $display("SUCCESS: LED output matches sent data ('A').");
        end else begin
            $display("ERROR: LED output does not match. Got %s, expected 'A'", led);
        end

        $display("Testbench for top_basys3 finished.");
        $finish;
    end
    
    // Clock generator
    always #5 clk = ~clk;

endmodule 