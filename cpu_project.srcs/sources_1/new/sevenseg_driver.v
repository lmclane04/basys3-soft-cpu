module sevenseg_driver(
    input clk,                  // 100 MHz clock from Basys3
    input rst,
    input [15:0] value,         // Value to display (4 hex digits)
    output reg [3:0] an,        // 4 active-low anodes
    output reg [6:0] seg        // 7 active-low cathodes (abcdefg)
);
    reg [1:0] digit = 0;
    reg [15:0] value_reg;
    reg [3:0] current_nibble;
    reg [16:0] refresh_counter = 0; // For multiplexing

    // Refresh rate: ~1 kHz per digit (assuming 100 MHz clock)
    always @(posedge clk) begin
        if (rst) begin
            refresh_counter <= 0;
            digit <= 0;
            value_reg <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter == 100_000) begin // ~1 kHz
                refresh_counter <= 0;
                digit <= digit + 1;
            end
            value_reg <= value;
        end
    end

    always @(*) begin
        case (digit)
            2'b00: current_nibble = value_reg[3:0];
            2'b01: current_nibble = value_reg[7:4];
            2'b10: current_nibble = value_reg[11:8];
            2'b11: current_nibble = value_reg[15:12];
        endcase
    end

    // 7-segment decoder (active low)
    always @(*) begin
        case (current_nibble)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
            default: seg = 7'b1111111;
        endcase
    end

    // Anode control (active low)
    always @(*) begin
        case (digit)
            2'b00: an = 4'b1110;
            2'b01: an = 4'b1101;
            2'b10: an = 4'b1011;
            2'b11: an = 4'b0111;
            default: an = 4'b1111;
        endcase
    end
endmodule 