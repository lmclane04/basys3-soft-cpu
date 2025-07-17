module rom (
    input [7:0] addr,
    output [7:0] data
);
    reg [7:0] memory[0:255];

    assign data = memory[addr];

    integer i;
    initial begin
        // 0: LOAD R1, [0x01] (00 01 000001)
        memory[0] = 8'b00010001;
        // 1: STORE R1, [0x02] (01 01 000010)
        memory[1] = 8'b01010010;
        // 2: LOAD R2, [0x02] (00 10 000010)
        memory[2] = 8'b00100010;
        // 3: STORE R2, [0x03] (01 10 000011)
        memory[3] = 8'b01100011;
        // 4: JMP 4 (11 000100)
        memory[4] = 8'b11000100;
        // Fill the rest with HALT for safety
        for (i = 5; i < 256; i = i + 1) begin
            memory[i] = 8'b11111111;
        end
    end
endmodule