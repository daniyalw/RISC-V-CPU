module tb_cpu_core;
    reg clk = 0, reset = 0, enable = 1;
    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    always #5 clk = ~clk; // set clock to 5 time units

    cpu_core uut (.clk(clk), .reset(reset), .enable(enable));

    task info_display;
        begin
            $display("pc=%h instr=%h branch_taken=%b branch_target=%h next_pc=%h alu_result=%h invalid=%b mem_read=%b mem_write=%b mem_to_reg=%b datamem_out=%h opcode=%b\n\n",
                uut.pc,
                uut.instruction,
                uut.branch_taken,
                uut.branch_target,
                uut.next_pc,
                uut.alu_result,
                uut.invalid_instruction,
                uut.scd.mem_read,
                uut.scd.mem_write,
                uut.scd.mem_to_reg,
                uut.scd.datamem_out,
                uut.instruction[6:0]);
        end
    endtask

    task check_task_ALU;
        input [31:0] expected_pc, expected_alu_result;

        begin
            num_tasks = num_tasks + 1;

            if ((uut.pc !== expected_pc) || (uut.alu_result !== expected_alu_result)) begin
                $display("Error, ALU test; test %0d: pc=%h (expected = %h) | instruction=%h | alu_result=%h (expected = %h) | invalid=%b", num_tasks, uut.pc, expected_pc, uut.instruction, uut.alu_result, expected_alu_result, uut.invalid_instruction);
                info_display();
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
                $display("Error, branch test; test %0d: uut.branch_taken = %b (expected = %b) | pc = %h (expected = %h)", num_tasks, uut.branch_taken, expected_branch_taken, uut.pc, expected_pc);
                info_display();
                error_count = error_count + 1;
            end
        end
    endtask

    task check_task_datamem;
        input [31:0] expected_pc, expected_val;
        input instr_type; // LW = 0, SW = 1

        begin
            num_tasks = num_tasks + 1;

            if (instr_type == 0) begin
                // LW
                if ((uut.pc !== expected_pc) || (uut.scd.datamem_out !== expected_val)) begin
                    $display("Error, lw data memory test; test %0d; uut.scd.datamem_out = %h (expected = %h) | pc = %h (expected = %h)", num_tasks, uut.scd.datamem_out, expected_val, uut.pc, expected_pc);
                    info_display();
                    error_count = error_count + 1;
                end
            end else if (instr_type == 1) begin
                // SW - rs2_data is what is written into the data memory
                if ((uut.pc !== expected_pc) || (uut.scd.rs2_data !== expected_val)) begin
                    $display("Error, sw data memory test; test %0d; uut.scd.rs2_data = %h (expected = %h) | pc = %h (expected = %h)", num_tasks, uut.scd.rs2_data, expected_val, uut.pc, expected_pc);
                    info_display();
                    error_count = error_count + 1;
                end
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
        check_task_ALU(32'd0, 32'd0);

        // test 2
        @(posedge clk); #1;
        check_task_ALU(32'd4, 32'd42);

        // test 3
        @(posedge clk); #1;
        check_task_datamem(32'd8, 32'd42, 1'b1);

        // test 4
        @(posedge clk); #1;
        check_task_datamem(32'd12, 32'd42, 1'b0);

        // test 5
        @(posedge clk); #1;
        check_task_ALU(32'd16, 32'd43);

        tb_final_display("cpu_core");

        $finish;
    end
endmodule
