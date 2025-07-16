module alu(
    input [7:0] a,
    input [7:0] b,
    input [1:0] op, // 00 = MOV, 01 = ADD, 10 = SUB
    output reg [7:0] result
);
    always @(*) begin
        case (op)
            2'b00: result = b;         // MOV
            2'b01: result = a + b;     // ADD
            2'b10: result = a - b;     // SUB
            default: result = 8'd0;
        endcase
    end
endmodule