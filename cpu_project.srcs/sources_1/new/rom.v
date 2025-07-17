module rom (
    input [7:0] addr,
    output [7:0] data
);
    reg [7:0] memory[0:255];

    assign data = memory[addr];

    initial begin
        // 0: MOV R0, R0 (00 00 00 00)
        memory[0] = 8'b00000000;
        // 1: MOV R1, R1 (00 01 01 00)
        memory[1] = 8'b00010100;
        // 2: ADD R0, R1 (01 00 01 00)
        memory[2] = 8'b01000100;
        // 3: ADD R0, R0 (01 00 00 00)
        memory[3] = 8'b01000000;
        // 4: BEQ R0, R1, +2 (10 00 01 10)
        memory[4] = 8'b10000110;
        // 5: JMP 0 (11 000000)
        memory[5] = 8'b11000000;
        // 6: ADD R3, R3 (01 11 11 00)
        memory[6] = 8'b01111100;
        // 7: JMP 7 (11 000111)
        memory[7] = 8'b11000111;
        // Fill the rest with HALT for safety
        integer i;
        for (i = 8; i < 256; i = i + 1) begin
            memory[i] = 8'b11111111;
        end
    end
endmodule