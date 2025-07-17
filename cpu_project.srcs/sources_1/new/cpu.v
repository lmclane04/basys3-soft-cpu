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
    wire reg_write_en;
    wire halt_out;
    wire is_jump;
    wire is_branch;
    reg [1:0] write_addr_reg;
    reg [7:0] alu_result_reg;
    reg halted = 0;

    wire [5:0] jmp_addr = instr[5:0];
    wire [1:0] beq_r1 = instr[5:4];
    wire [1:0] beq_r2 = instr[3:2];
    wire [1:0] beq_offset = instr[1:0];

    rom imem(.addr(pc), .data(instr));
    regfile regs(
        .clk(clk),
        .read_addr1(dst),
        .read_addr2(src),
        .write_addr(write_addr_reg),
        .write_data(alu_result_reg),
        .write_enable(reg_write_en),
        .read_data1(rd1),
        .read_data2(rd2)
    );
    alu alu_inst(.a(rd1), .b(rd2), .op(opcode), .result(alu_result));
    control control_unit(
        .opcode(opcode),
        .rst(rst),
        .reg_write_en(reg_write_en),
        .halt_out(halt_out),
        .is_jump(is_jump),
        .is_branch(is_branch)
    );

    always @(posedge clk) begin
        if (rst) begin
            pc <= 0;
            halted <= 0;
        end else if (!halted) begin
            alu_result_reg <= alu_result;
            write_addr_reg <= dst;
            if (halt_out) begin
                halted <= 1;
            end
            if (is_jump) begin
                pc <= {2'b00, jmp_addr};
            end else if (is_branch && (rd1 == rd2)) begin
                pc <= pc + beq_offset;
            end else begin
                pc <= pc + 1;
            end
        end
    end

    assign out_led = regs.regs[3]; // Show R3 result on LEDs
endmodule