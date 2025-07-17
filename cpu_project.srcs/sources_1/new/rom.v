module rom (
    input [7:0] addr,
    output [7:0] data
);
    reg [7:0] memory[0:255];

    assign data = memory[addr];

    integer i;
    initial begin
        // 0: LOAD R1, [0xF1] (00 01 111001)
        memory[0] = 8'b00011111; // R1, address 0xF1
        // 1: STORE R1, [0xF0] (01 01 111000)
        memory[1] = 8'b01011110; // R1, address 0xF0
        // 2: STORE R1, [0xF2] (01 01 111010)
        memory[2] = 8'b01011111; // R1, address 0xF2
        // 3: JMP 0x03 (11 000011)
        memory[3] = 8'b11000011;
        // Fill the rest with HALT for safety
        for (i = 4; i < 256; i = i + 1) begin
            memory[i] = 8'b11111111;
        end
    end
endmodule