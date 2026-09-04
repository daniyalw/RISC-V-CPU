module register_file (input clk, reset, write_enable, input [4:0] rs1_addr, rs2_addr, rd_addr, input [31:0] rd_data, output reg [31:0] rs1_data, rs2_data);
    reg [31:0] x[31:0]; // 32 registers, each 32-bits wide
    integer i;

    always @ (*) begin
        if (rs1_addr == 0)
            rs1_data = {32{1'b0}}; // since x0 is always 0
        else
            rs1_data = x[rs1_addr];
    end

    always @ (*) begin
        if (rs2_addr == 0)
            rs2_data = {32{1'b0}}; // since x0 is always 0
        else
            rs2_data = x[rs2_addr];
    end

    always @ (posedge clk or posedge reset) begin
        if (reset) begin // wipe all registers to zero
            for (i = 0; i < 32; i = i + 1) begin
                x[i] <= 32'b0;
            end
        end else if ((write_enable == 1) && (rd_addr != 5'd0)) // if register is not zero (due to x0 always being 0 in RISC-V), then write
            x[rd_addr] <= rd_data;
    end
endmodule
