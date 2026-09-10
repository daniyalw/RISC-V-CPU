module tb_single_cycle_datapath;
    reg [31:0] instruction;
    reg clk = 0, reset = 0;
    wire [31:0] rs1_data, alu_result;
    wire invalid_instruction;

    integer num_tasks = 0, error_count = 0;

    always #5 clk = ~clk;

    `include "tb/tb_final_display.vh"

    single_cycle_datapath uut (.instruction(instruction), .clk(clk), .reset(reset), .alu_result(alu_result), .invalid_instruction(invalid_instruction));

    task check_task;
        input [31:0] input_instruction;
        input [31:0] expected_result;
        input [4:0] port1;

        begin
            num_tasks = num_tasks + 1;
            instruction = input_instruction;

            #1;

            if ((alu_result !== expected_result) || (invalid_instruction !== 0)) begin
                $display("Error: test = %0d | ALU result = %h (expected = %h), register x%0d value = %h (expected = %h)", num_tasks, alu_result, expected_result, port1, uut.rs1_data, expected_result);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/single_cycle_datapath.vcd");
        $dumpvars(0, tb_single_cycle_datapath);

        $display("Running single-cycle datapath tests...");

        reset = 1;
        #1;
        reset = 0;
        #1;

        // test 1
        check_task({12'd5, 5'd0, 3'b000, 5'd1, 7'b0010011}, 32'd5, 1); // addi x1, x0, 5

        // test 2
        @(posedge clk);
        check_task({12'd0, 5'd1, 3'b000, 5'd2, 7'b0010011}, 32'd5, 2); // addi x2, x1, 0; if x2 ALU result is 5, then it proves x1 was written correctly in test 1

        // test 3
        @(posedge clk);
        check_task({7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011}, 32'd10, 3); // add x3, x1, x2;

        // test 4
        @(posedge clk);
        check_task({12'd0, 5'd3, 3'b000, 5'd4, 7'b0010011}, 32'd10, 4); //addi x4, x3, 0

        tb_final_display("single_cycle_datapath");

        $finish;
    end
endmodule
