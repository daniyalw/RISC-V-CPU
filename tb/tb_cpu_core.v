module tb_cpu_core;
    reg clk = 0, reset = 0, enable = 1;
    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    always #5 clk = ~clk; // set clock to 5 time units

    cpu_core uut (.clk(clk), .reset(reset), .enable(enable));

    task check_task;
        input [31:0] expected_pc, expected_alu_result;

        begin
            num_tasks = num_tasks + 1;

            if ((uut.pc !== expected_pc) || (uut.alu_result !== expected_alu_result)) begin
                $display("Error: instruction %0d failed: pc = %h (expected = %h), ALU result = %h (expected = %h)", num_tasks, uut.pc, expected_pc, uut.alu_result, expected_alu_result);
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

        // 0, 4, 8, 12 are the program counter, and the 5, 5, 10, 10 are the ALU results from the four operations in the hardcoded instruction memory
        // test 1
        check_task(0, 5);

        // test 2
        @(posedge clk); #1;
        check_task(4, 5);

        // test 3
        @(posedge clk); #1;
        check_task(8, 10);

        // test 4
        @(posedge clk); #1;
        check_task(12, 10);

        tb_final_display("cpu_core");

        $finish;
    end
endmodule
