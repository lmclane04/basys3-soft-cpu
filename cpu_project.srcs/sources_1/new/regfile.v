`timescale 1ns / 1ps

module regfile (
    input clk,
    input [1:0] read_addr1, read_addr2,
    input [1:0] write_addr,
    input [7:0] write_data,
    input write_enable,
    output [7:0] read_data1, read_data2
);
    reg [7:0] regs[3:0];
    
    initial begin
        regs[0] = 8'd0;
        regs[1] = 8'd5;
        regs[2] = 8'd3;
        regs[3] = 8'd0;
    end

    assign read_data1 = regs[read_addr1];
    assign read_data2 = regs[read_addr2];

    always @(posedge clk) begin
        if (write_enable)
            regs[write_addr] <= write_data;
    end
    
    always @(posedge clk) begin
        $display("R0=%d R1=%d R2=%d R3=%d", regs[0], regs[1], regs[2], regs[3]);
    end

endmodule