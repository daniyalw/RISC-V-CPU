module tb_register_file;
    reg clk = 0, reset = 0, write_enable = 0;
    reg [4:0] rs1_addr, rs2_addr, rd_addr;
    reg [31:0] rd_data;
    wire [31:0] rs1_data, rs2_data;

    integer num_tasks = 0, error_count = 0, i;

    `include "tb/tb_final_display.vh"

    always #5 clk = ~clk;

    register_file reg_file (.clk(clk), .reset(reset), .write_enable(write_enable), .rs1_addr(rs1_addr), .rs2_addr(rs2_addr), .rd_addr(rd_addr), .rd_data(rd_data), .rs1_data(rs1_data), .rs2_data(rs2_data));

    initial begin
        $dumpfile("waves/register_file.vcd");
        $dumpvars(0, tb_register_file);

        $display("Running register file tests...");

        // test case 1 - reset clears registers
        num_tasks = num_tasks + 1;
        reset = 1;
        #1;
        reset = 0;

        for (i = 0; i < 32; i = i + 1) begin
            rs1_addr = i;
            #1;

            if (rs1_data !== 32'b0) begin
                $display("Error: register x%b is not equal to zero after reset!", i);
                error_count = error_count + 1;
            end

        end

        // test case 2 - write x1, read x1
        num_tasks = num_tasks + 1;
        write_enable = 1;
        rd_addr = 1; // x1
        rd_data = 32'hDEADBEEF;
        rs1_addr = 1; // x1
        @(posedge clk); #1;

        if (rs1_data !== 32'hDEADBEEF) begin
            $display("Error: register x1 is not equal to 0xDEADBEEF after writing 0xDEADBEEF to register x1.");
            error_count = error_count + 1;
        end

        // test case 3 - write x2, read x2
        num_tasks = num_tasks + 1;
        write_enable = 1;
        rd_addr = 2; // x2
        rd_data = 32'h12345678;
        rs1_addr = 2; // x2
        @(posedge clk); #1;

        write_enable = 0;

        if (rs1_data !== 32'h12345678) begin
            $display("Error: register x2 is not equal to 0x12345678 after writing 0x12345678 to register x2.");
            error_count = error_count + 1;
        end

        // test case 4 - read x1 and x2 at the same time
        num_tasks = num_tasks + 1;
        rs1_addr = 1; // x1
        rs2_addr = 2; // x2
        #1;

        if ((rs1_data !== 32'hDEADBEEF) || (rs2_data !== 32'h12345678)) begin
            $display("Error: reading registers x1 and x2 do not provide the correct values of 0xDEADBEEF and 0x12345678 respectively.");
            error_count = error_count + 1;
        end

        // test case 5 - write_enable = 0 prevents write
        write_enable = 0;
        num_tasks = num_tasks + 1;
        rd_addr = 1;
        rd_data = 32'h12345678;
        rs1_addr = 1;
        @(posedge clk); #1;

        if (rs1_data !== 32'hDEADBEEF) begin
            $display("Error: write_enable = 0 did not prevent write.");
            error_count = error_count + 1;
        end

        // test case 6 - write to x0 is ignored
        num_tasks = num_tasks + 1;
        write_enable = 1;
        rd_addr = 0;
        rd_data = 32'h12345678;
        rs1_addr = 0;
        @(posedge clk); #1;

        write_enable = 0;

        if (rs1_data !== 32'h00000000) begin
            $display("Error: x0 did not remain zero after write.");
            error_count = error_count + 1;
        end

        // test case 7 - x0 always reads 0
        num_tasks = num_tasks + 1;
        #1;

        // rs1_addr is already set to zero from previous test case
        if (rs1_data !== 32'h00000000) begin
            $display("Error: x0 is not always 0.");
            error_count = error_count + 1;
        end

        // test case 8 - overwrite x1 with a new value
        num_tasks = num_tasks + 1;
        write_enable = 1;
        rd_addr = 1;
        rd_data = 32'hCAFEBABE;
        rs1_addr = 1;
        @(posedge clk); #1;

        write_enable = 0;

        if (rs1_data !== 32'hCAFEBABE) begin
            $display("Error: x1 was not overwritten.");
            error_count = error_count + 1;
        end

        tb_final_display("register_file");

        $finish;
    end
endmodule
