module rom (
    input [7:0] addr,
    output [7:0] data
);
    reg [7:0] memory[0:255];

    assign data = memory[addr];

    initial begin
        memory[0] = 8'b01100100; // ADD R3 = R1 + R2
        memory[1] = 8'b11111111; // HALT
    end
endmodule