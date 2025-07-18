`timescale 1ns / 1ps

module uart_tb;

    // Inputs
    reg clk_100mhz;
    reg rx;
    reg tx_start;
    reg [7:0] tx_data;

    // Outputs
    wire tx_busy;
    wire rx_strobe;
    wire [7:0] rx_data;
    wire tx;

    // Instantiate the Unit Under Test (UUT)
    uart uut (
        .clk_50mhz(clk_100mhz), // Connected to 100MHz clock
        .rx(rx),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_busy(tx_busy),
        .rx_strobe(rx_strobe),
        .rx_data(rx_data),
        .tx(tx)
    );
    
    // Baud rate parameters for 100MHz clock
    localparam BAUD_RATE = 115200;
    localparam CLK_FREQ = 100_000_000;
    localparam BIT_PERIOD = CLK_FREQ / BAUD_RATE;

    initial begin
        // Initialize Inputs
        clk_100mhz = 0;
        rx = 1;
        tx_start = 0;
        tx_data = 0;

        // Wait for global reset
        #100;
        
        $display("Testbench Started");

        // --- Test UART Transmission ---
        $display("Testing UART Transmission (TX)...");
        tx_data <= "H"; // ASCII for 'H'
        tx_start <= 1;
        #10; // Pulse for one clock cycle
        tx_start <= 0;

        wait (tx_busy);
        $display("TX busy detected.");
        wait (~tx_busy);
        $display("TX finished.");
        
        // --- Test UART Reception ---
        $display("Testing UART Reception (RX)...");
        // Send 'W' to the receiver
        send_byte("W");
        
        wait(rx_strobe);
        if (rx_data == "W") begin
            $display("SUCCESS: Received data matches sent data ('W').");
        end else begin
            $display("ERROR: Received data does not match. Got %s, expected 'W'", rx_data);
        end

        #100;
        $display("Testbench Finished");
        $finish;
    end

    // Clock generator
    always #5 clk_100mhz = ~clk_100mhz;
    
    // Task to send a byte serially to the RX pin
    task send_byte(input [7:0] data);
        integer i;
        begin
            // Start bit
            rx = 0;
            #(BIT_PERIOD);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD);
            end

            // Stop bit
            rx = 1;
            #(BIT_PERIOD);
        end
    endtask

endmodule 