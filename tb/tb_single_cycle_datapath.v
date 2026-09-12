module tb_single_cycle_datapath;
    reg [31:0] instruction, pc, target;
    wire [31:0] rs1_data, alu_result, branch_target;
    reg clk = 0, reset = 0;
    wire invalid_instruction, branch_taken;

    integer num_tasks = 0, error_count = 0;

    always #5 clk = ~clk;

    `include "tb/tb_final_display.vh"

    single_cycle_datapath uut (.instruction(instruction), .clk(clk), .reset(reset), .alu_result(alu_result), .invalid_instruction(invalid_instruction), .branch_taken(branch_taken), .branch_target(branch_target));

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

    task check_branch_task;
        input [31:0] input_instruction, test_pc;
        input expected_taken;
        input [31:0] expected_target;

        begin
            // we put reg [31:0] pc, target at the beginning of the testbench in order to somewhat simulate the program counter
            num_tasks = num_tasks + 1;
            instruction = input_instruction;
            pc = test_pc;
            target = pc + uut.immediate;

            #1;

            if ((branch_taken !== expected_taken) || (target !== expected_target)) begin
                $display("Error: test = %0d, instruction = %h, pc = %h | branch_taken = %b (expected = %b), branch_target = %h (expected = %h)", num_tasks, instruction, uut.pc, branch_taken, expected_taken, branch_target, expected_target);
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

        // test 5
        @(posedge clk);
        check_branch_task({1'b0, 6'b000000, 5'd0, 5'd0, 3'b000, 4'b0010, 1'b0, 7'b1100011}, 32'd4, 1'b1, 32'd4); //beq x0, x0, 4

        tb_final_display("single_cycle_datapath");

        $finish;
    end
endmodule
