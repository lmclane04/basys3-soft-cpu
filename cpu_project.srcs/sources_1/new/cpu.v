module cpu(
    input clk,
    input rst,
    input [7:0] switches,      // Basys3 switches
    output reg [7:0] led_out,  // Basys3 LEDs
    output reg [7:0] display_out // Basys3 7-segment display (to be decoded)
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
    wire ram_write_en;
    wire is_load;
    wire is_store;
    reg [1:0] write_addr_reg;
    reg [7:0] alu_result_reg;
    reg halted = 0;

    wire [5:0] jmp_addr = instr[5:0];
    wire [1:0] beq_r1 = instr[5:4];
    wire [1:0] beq_r2 = instr[3:2];
    wire [1:0] beq_offset = instr[1:0];
    wire [1:0] mem_reg = instr[5:4];
    wire [5:0] mem_addr = instr[3:0];
    wire [7:0] ram_dout;

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
    ram data_ram(
        .clk(clk),
        .we(ram_write_en & (instr[5:0] != 8'hF0) & (instr[5:0] != 8'hF2)), // Don't write to RAM for LED or display-mapped address
        .addr({2'b00, instr[5:0]}),
        .din(rd1), // For STORE, write register value
        .dout(ram_dout)
    );
    control control_unit(
        .opcode(opcode),
        .rst(rst),
        .reg_write_en(reg_write_en),
        .ram_write_en(ram_write_en),
        .halt_out(halt_out),
        .is_jump(is_jump),
        .is_branch(is_branch),
        .is_load(is_load),
        .is_store(is_store)
    );

    always @(posedge clk) begin
        if (rst) begin
            pc <= 0;
            halted <= 0;
            led_out <= 0;
            display_out <= 0;
        end else if (!halted) begin
            if (is_load) begin
                if (instr[5:0] == 8'hF1) begin
                    alu_result_reg <= switches; // Memory-mapped switches
                end else begin
                    alu_result_reg <= ram_dout;
                end
                write_addr_reg <= instr[5:4];
            end else if (is_store) begin
                if (instr[5:0] == 8'hF0) begin
                    led_out <= rd1; // Memory-mapped LEDs
                end
                if (instr[5:0] == 8'hF2) begin
                    display_out <= rd1; // Memory-mapped 7-segment display
                end
                write_addr_reg <= 0;
                alu_result_reg <= 0;
            end else begin
                alu_result_reg <= alu_result;
                write_addr_reg <= dst;
            end
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
endmodule