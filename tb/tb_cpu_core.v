module tb_cpu_core;
    reg clk = 0, reset = 0, enable = 1;
    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    always #5 clk = ~clk; // set clock to 5 time units

    cpu_core uut (.clk(clk), .reset(reset), .enable(enable));

    task check_task_ALU;
        input [31:0] expected_pc, expected_alu_result;

        begin
            num_tasks = num_tasks + 1;

            if ((uut.pc !== expected_pc) || (uut.alu_result !== expected_alu_result)) begin
                $display("pc=%h instr=%h branch_taken=%b branch_target=%h next_pc=%h alu=%h invalid=%b",
         uut.pc,
         uut.instruction,
         uut.branch_taken,
         uut.branch_target,
         uut.next_pc,
         uut.alu_result,
         uut.invalid_instruction);
                $display("Error, ALU test; test %0d: pc=%h (expected = %h) | instruction=%h | alu_result=%h (expected = %h) | invalid=%b", num_tasks, uut.pc, expected_pc, uut.instruction, uut.alu_result, expected_alu_result, uut.invalid_instruction);
                error_count = error_count + 1;
            end
        end
    endtask

    task check_task_branch;
        input [31:0] expected_pc;
        input expected_branch_taken;

        begin
            num_tasks = num_tasks + 1;

            if ((uut.pc !== expected_pc) || (uut.branch_taken !== expected_branch_taken)) begin
                $display("pc=%h instr=%h branch_taken=%b branch_target=%h next_pc=%h alu=%h invalid=%b",
         uut.pc,
         uut.instruction,
         uut.branch_taken,
         uut.branch_target,
         uut.next_pc,
         uut.alu_result,
         uut.invalid_instruction);
                $display("Error, branch test; test %0d: uut.branch_taken = %b (expected = %b) | pc = %h (expected = %h)", num_tasks, uut.branch_taken, expected_branch_taken, uut.pc, expected_pc);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/cpu_core.vcd");
        $dumpvars(0, tb_cpu_core);

        $display("Running CPU core tests...");

        reset = 1;
        #1;
        reset = 0;
        #1;

        // program counter advances by 4 each time (0, 4, 8, ...), the second param in check_task is the ALU result of the operation
        // test 1
        check_task_ALU(32'd0, 32'd5);

        // test 2
        @(posedge clk); #1;
        check_task_ALU(32'd4, 32'd5);

        // test 3
        @(posedge clk); #1;
        check_task_branch(32'd8, 1);

        // test 4
        @(posedge clk); #1;
        check_task_ALU(32'd16, 32'd42);

        // test 5
        @(posedge clk); #1;
        check_task_branch(32'd20, 0);

        // test 6
        @(posedge clk); #1;
        check_task_ALU(32'd24, 7);

        tb_final_display("cpu_core");

        $finish;
    end
endmodule
