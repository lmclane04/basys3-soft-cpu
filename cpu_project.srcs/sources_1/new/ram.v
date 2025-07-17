module ram (
    input clk,
    input we,                // Write enable
    input [7:0] addr,        // 8-bit address
    input [7:0] din,         // Data input (write)
    output [7:0] dout        // Data output (read)
);
    reg [7:0] memory[0:255];

    always @(posedge clk) begin
        if (we)
            memory[addr] <= din;
    end

    assign dout = memory[addr];
endmodule 