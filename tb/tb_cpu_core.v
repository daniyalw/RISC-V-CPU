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
                $display("pc=%h | instruction=%h | alu_result=%h | invalid=%b", uut.pc, uut.instruction, uut.alu_result, uut.invalid_instruction);
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
        check_task(0, 32'd12);

        // test 2
        @(posedge clk); #1;
        check_task(4, 32'd8);

        // test 3
        @(posedge clk); #1;
        check_task(8, 32'd11);

        // test 4
        @(posedge clk); #1;
        check_task(12, 32'd4);

        // test 5
        @(posedge clk); #1;
        check_task(16, 32'd16);

        // test 6
        @(posedge clk); #1;
        check_task(20, 32'd8);

        // test 7
        @(posedge clk); #1;
        check_task(24, 32'd0);

        tb_final_display("cpu_core");

        $finish;
    end
endmodule
