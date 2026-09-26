module tb_single_cycle_datapath;
    reg [31:0] instruction, pc, target;
    wire [31:0] alu_result, branch_target;
    reg clk = 0, reset = 0;
    wire invalid_instruction, branch_taken;

    integer num_tasks = 0, error_count = 0, i;

    always #5 clk = ~clk;

    `include "tb/tb_final_display.vh"

    single_cycle_datapath uut (.instruction(instruction), .clk(clk), .reset(reset), .pc(pc), .alu_result(alu_result), .invalid_instruction(invalid_instruction), .branch_taken(branch_taken), .branch_target(branch_target));

    task check_task;
        input [31:0] input_instruction;
        input [31:0] expected_result;
        input [4:0] port1; // register

        begin
            num_tasks = num_tasks + 1;
            instruction = input_instruction;

            @(posedge clk);
            #1;

            if ((uut.rf.x[port1] !== expected_result) || (invalid_instruction !== 0)) begin
                $display("Error: test=%0d   instruction=%h | uut.rf.x[%0d]=%h (expected=%h)",
                            num_tasks, instruction,
                            port1, uut.rf.x[port1], expected_result);
                error_count = error_count + 1;
            end
        end
    endtask

    task check_auipc;
        input [31:0] input_instruction, expected_result, test_pc;
        input [4:0] port1;

        begin
            num_tasks = num_tasks + 1;
            instruction = input_instruction;
            pc = test_pc;

            @(posedge clk);
            #1;

            if ((uut.rf.x[port1] !== expected_result) || (invalid_instruction !== 0)) begin
                $display("Error: test=%0d   instruction=%h | uut.rf.x[%0d]=%h (expected=%h)",
                            num_tasks, instruction,
                            port1, uut.rf.x[port1], expected_result);
                error_count = error_count + 1;
            end
        end
    endtask

    task check_branch_task;
        input [31:0] input_instruction, test_pc;
        input expected_taken;
        input [31:0] expected_target;
        input [4:0] port1;

        begin
            // we put reg [31:0] pc, target at the beginning of the testbench in order to somewhat simulate the program counter
            num_tasks = num_tasks + 1;
            instruction = input_instruction;
            pc = test_pc;

            @(posedge clk);
            #1;

            // also check that the register has actually written the return address (pc+4) for JAL/JALR instructions
            if ((branch_taken !== expected_taken) || (branch_target !== expected_target) || (uut.jal_enable && (port1 !== 0) && (uut.rf.x[port1] !== (pc + 4)))) begin
                $display("Error: test=%0d   instruction=%h   opcode=%b   pc=%h   immediate=%h   rs1_data=%h | branch_taken=%b (expected=%b)   target=%h (expected=%h)\n", num_tasks, instruction, instruction[6:0], pc, uut.immediate, uut.rs1_data, branch_taken, expected_taken, uut.branch_target, expected_target);
            end
        end
    endtask

    task check_mem_task;
        input [31:0] input_instruction, expected_datamem, expected_address;
        input store; // store = 0 if lw, store = 1 if sw

        begin
            num_tasks = num_tasks + 1;
            instruction = input_instruction;

            @(posedge clk);
            #1;

            if (store == 0) begin
                // lw
                if ((uut.mem_read !== 1'b1) || (uut.mem_write !== 1'b0) || (uut.mem_to_reg !== 1'b1) || (uut.datamem_out !== expected_datamem) || (alu_result !== expected_address)) begin
                    $display("Error: test=%0d instruction=%h | mem_read=%b (expected=%b)   mem_write=%b (expected = %b)   mem_to_reg=%b (expected=%b)   datamem_out=%h (expected=%h)   alu_result=%h (expected=%h)", num_tasks, instruction, uut.mem_read, 1'b1, uut.mem_write, 1'b0, uut.mem_to_reg, 1'b1, uut.datamem_out, expected_datamem, alu_result, expected_address);
                    error_count = error_count + 1;
                end
            end else if (store == 1) begin
                // sw
                if ((uut.mem_read !== 1'b0) || (uut.mem_write !== 1'b1) || (uut.mem_to_reg !== 1'b0) || (alu_result !== expected_address)) begin
                    $display("Error: test=%0d instruction=%h | mem_read=%b (expected=%b)   mem_write=%b (expected = %b)   mem_to_reg=%b (expected=%b)   alu_result=%h (expected=%h)", num_tasks, instruction, uut.mem_read, 1'b0, uut.mem_write, 1'b1, uut.mem_to_reg, 1'b0, alu_result, expected_address);
                    error_count = error_count + 1;
                end
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
        check_task(32'h00500093, 32'd5, 1); // addi x1, x0, 5

        // test 2
        check_task({12'd0, 5'd1, 3'b000, 5'd2, 7'b0010011}, 32'd5, 2); // addi x2, x1, 0; if x2 ALU result is 5, then it proves x1 was written correctly in test 1

        // test 3
        check_task({7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011}, 32'd10, 3); // add x3, x1, x2; x3=x1+x2=5+5=10

        // test 4
        check_task({12'd0, 5'd3, 3'b000, 5'd4, 7'b0010011}, 32'd10, 4); //addi x4, x3, 0

        // test 5
        check_branch_task({1'b0, 6'b000000, 5'd0, 5'd0, 3'b000, 4'b0010, 1'b0, 7'b1100011}, 32'd4, 1'b1, 32'd8, 5'd0); //beq x0, x0, 4

        // test 6
        check_branch_task(32'h00208463, 32'h00000008, 1'b1, 32'h00000010, 5'd0); // beq x1, x2, 8

        // test 7
        check_branch_task(32'h00209463, 32'h00000014, 1'b0, 32'h0000001c, 5'd0); // bne x1, x2, 8

        // test 8
        check_mem_task(32'h0020a023, 32'd0, 32'd5, 1); // sw x2, 0(x1) - storing the value 5 (since x2=5) at addr=0+x1

        // test 9
        check_mem_task(32'h0000a183, 32'd5, 32'd5, 0); // lw x3, 0(x1) - loading the value 5 into x3 from addr=0+x1

        // test 10
        check_task(32'h00118213, 32'd6, 5'd4); // addi x4, x3, 1; x4 = x3 + 1 = 5 + 1 = 6

        // test 11
        check_branch_task(32'h008002ef, 32'd4, 1'b1, 32'd12, 5'd5); // jal x5, +8

        // test 12
        check_branch_task(32'h00C000EF, 32'd8, 1'b1, 32'd20, 5'd1); // jal x1, 12

        // test 13
        check_branch_task(32'hFFDFF0EF, 32'd4, 1'b1, 32'd0, 5'd1); // jal x1, -4

        // test 14
        check_branch_task(32'h0040006F, 32'd12, 1'b1, 32'd16, 5'd0); // jal x0, 4; the equivalent of j 4

        // two tests to reset x1 and x2 values
        // test 15
        check_task(32'h00400113, 32'd4, 2); // addi x2, x0, 4

        // test 16
        check_branch_task(32'h000100E7, 32'd48, 1'b1, 32'd4, 5'd1); // jalr x1, x2, 0; target = 0 + x2 = x2 = 4

        // test 17
        check_branch_task(32'h004100E7, 32'd0, 1'b1, 32'd8, 5'd1); // jalr x1, x2, 4; target = x2 + 4 = 4 + 4 = 8

        // test 18
        check_branch_task(32'hFFC100E7, 32'd16, 1'b1, 32'd0, 5'd1); // jalr x1, x2, -4; target = x2 - 4 = 4 - 4 = 0

        // test 19
        check_task(32'h00800093, 32'd8, 1); // addi x1, x0, 8

        // test 20
        check_branch_task(32'h00008067, 32'd8, 1'b1, 32'd8, 5'd0); // jalr x0, x1, 0; target = x1 + 0 = x1 = 8

        // test 21
        check_branch_task(32'h004082E7, 32'd52, 1'b1, 32'd12, 5'd5); // jalr x5, x1, 4; target = x1 + 4 = 8 + 4 = 12

        // test 22
        check_task(32'h00400113, 32'd4, 2); // addi x2, x0, 4

        // test 23
        check_branch_task(32'hFFC10067, 32'd4, 1'b1, 32'd0, 5'd0); // jalr x0, x2, -4; target = x2 - 4 = 4 - 4 = 0

        // test 24
        check_task(32'h12345137, 32'h12345000, 32'd2); // lui x2, 0x12345

        // test 25
        check_auipc(32'h12345097, 32'h12345000, 32'd0, 5'd1); // auipc x1, 0x12345

        // test 26
        check_auipc(32'h00000117, 32'h00000004, 32'd4, 5'd2); // auipc x2, 0x00000

        // test 27
        check_auipc(32'h00001197, 32'h00001008, 32'd8, 5'd3); // auipc x3, 0x00001

        // test 28
        check_auipc(32'hFFFFF217, 32'hFFFFF00C, 32'd12, 5'd4); // auipc x4, 0xFFFFF

        tb_final_display("single_cycle_datapath");

        $finish;
    end
endmodule
