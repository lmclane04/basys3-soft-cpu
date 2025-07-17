`timescale 1ns / 1ps

module control(
    input [1:0] opcode,
    input rst,
    output reg reg_write_en,
    output reg halt_out,
    output reg is_jump,
    output reg is_branch
);
    always @(*) begin
        if (rst) begin
            reg_write_en = 1'b0;
            halt_out = 1'b0;
            is_jump = 1'b0;
            is_branch = 1'b0;
        end else begin
            case (opcode)
                2'b00: begin // MOV
                    reg_write_en = 1'b1;
                    halt_out = 1'b0;
                    is_jump = 1'b0;
                    is_branch = 1'b0;
                end
                2'b01: begin // ADD
                    reg_write_en = 1'b1;
                    halt_out = 1'b0;
                    is_jump = 1'b0;
                    is_branch = 1'b0;
                end
                2'b10: begin // BEQ
                    reg_write_en = 1'b0;
                    halt_out = 1'b0;
                    is_jump = 1'b0;
                    is_branch = 1'b1;
                end
                2'b11: begin // JMP
                    reg_write_en = 1'b0;
                    halt_out = 1'b0;
                    is_jump = 1'b1;
                    is_branch = 1'b0;
                end
                default: begin
                    reg_write_en = 1'b0;
                    halt_out = 1'b0;
                    is_jump = 1'b0;
                    is_branch = 1'b0;
                end
            endcase
        end
    end
endmodule
