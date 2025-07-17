module top_basys3_tb;
    reg clk = 0;
    reg rst = 1;
    reg [7:0] sw = 8'b00000000;
    wire [7:0] led;
    wire [6:0] seg;
    wire [3:0] an;

    top_basys3 uut (
        .clk(clk),
        .rst(rst),
        .sw(sw),
        .led(led),
        .seg(seg),
        .an(an)
    );

    // Clock generation (simulate 100 MHz)
    always #5 clk = ~clk;

    initial begin
        // Reset pulse
        #20 rst = 0;

        // Set switches to a value
        sw = 8'b10101010;
        #100;
        $display("[t=%0t] LED: %b, SEG: %b, AN: %b", $time, led, seg, an);

        // Change switches
        sw = 8'b11001100;
        #100;
        $display("[t=%0t] LED: %b, SEG: %b, AN: %b", $time, led, seg, an);

        // Change switches again
        sw = 8'b00001111;
        #100;
        $display("[t=%0t] LED: %b, SEG: %b, AN: %b", $time, led, seg, an);

        $finish;
    end
endmodule 