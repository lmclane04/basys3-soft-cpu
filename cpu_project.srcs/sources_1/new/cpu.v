module cpu(
    input clk,
    input rst,
    output [7:0] out_led
);
    reg [7:0] pc = 0;
    wire [7:0] instr;

    wire [1:0] opcode = instr[7:6];
    wire [1:0] dst = instr[5:4];
    wire [1:0] src = instr[3:2];

    wire [7:0] rd1, rd2, alu_result;
    reg write_enable;
    reg [1:0] write_addr;
    reg [7:0] alu_result_reg;
    reg [1:0] write_addr_reg;
    reg write_enable_reg;

    rom imem(.addr(pc), .data(instr));
    regfile regs(
        .clk(clk),
        .read_addr1(dst),
        .read_addr2(src),
        .write_addr(write_addr_reg),
        .write_data(alu_result_reg),
        .write_enable(write_enable_reg),
        .read_data1(rd1),
        .read_data2(rd2)
    );
    alu alu_inst(.a(rd1), .b(rd2), .op(opcode), .result(alu_result));

    reg halted = 0;

    
    always @(posedge clk) begin
        if (rst) begin
            pc <= 0;
            halted <= 0;
            write_enable <= 0;
        end else if (!halted) begin
            alu_result_reg <= alu_result;
            write_addr_reg <= dst;
            write_enable_reg <= 0;
            
            case (opcode)
//                2'b00: begin // MOV: dst = src
//                    write_addr <= dst;
//                    write_enable <= 1;
//                end
                2'b01: begin // ADD
                    write_enable_reg <= 1;
                end
//                2'b10: begin // SUB
//                    write_addr <= dst;
//                    write_enable <= 1;
//                end
                2'b11: begin // HALT
                    halted <= 1;
                end
                default: begin
                    write_enable <= 0;
                end
            endcase
            pc <= pc + 1;
        end else begin
            write_enable_reg <= 0;
        end
    end

    assign out_led = regs.regs[3]; // Show R3 result on LEDs
endmodule