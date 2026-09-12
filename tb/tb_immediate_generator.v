module tb_immediate_generator;
    reg [31:0] instruction;
    wire [31:0] immediate;

    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    immediate_generator uut (.instruction(instruction), .immediate(immediate));

    task check_i_task;
        input [11:0] twelve_bit_immediate;
        input [31:0] expected;

        begin
            num_tasks = num_tasks + 1;

            instruction = {twelve_bit_immediate, 5'd0, 3'b000, 5'd1, 7'b0010011};

            #1; // 1 time unit

            if (immediate !== expected) begin
                $display("Error: instruction: %h, opcode = %b | immediate = %h (expected = %h)", instruction, uut.opcode, immediate, expected);
                error_count = error_count + 1;
            end
        end
    endtask

    // B-type immedaites are more complicated, that's why I just put the entire test instruction as an input instead of manually constructing the instruction like I did for the I-type ones
    task check_b_task;
        input [31:0] test_instruction;
        input [31:0] expected;

        begin
            num_tasks = num_tasks + 1;
            instruction = test_instruction;

            #1;

            if (immediate !== expected) begin
                $display("Error: instruction: %h, opcode = %b | immediate: %h (expected = %h)", instruction, uut.opcode, immediate, expected);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/immediate_generator.vcd");
        $dumpvars(0, tb_immediate_generator);

        $display("Running immediate generator tests...");

        // I-type tests (pretty straightforward compared to B-type)
        // test 1
        check_i_task(12'h000, 32'h00000000);

        // test 2
        check_i_task(12'h001, 32'h00000001);

        // test 3
        check_i_task(12'h005, 32'h00000005);

        // test 4
        check_i_task(12'h7FF, 32'h000007FF);

        // test 5
        check_i_task(12'h800, 32'hFFFFF800);

        // test 6
        check_i_task(12'hFFF, 32'hFFFFFFFF);

        // test 7
        check_i_task(12'hFF0, 32'hFFFFFFF0);

        // B-type tests - taken from objdump
        // beq x1, x2, 8
        check_b_task(32'h00208463, 32'h00000008);

        // bne x1, x2, 8
        check_b_task(32'h00209463, 32'h00000008);

        // beq x0, x0, 4
        check_b_task({1'b0, 6'b000000, 5'd0, 5'd0, 3'b000, 4'b0010, 1'b0, 7'b1100011}, 32'h00000004); // should I just replace this with the hex version

        // beq x0, x0, 12
        check_b_task({1'b0, 6'b000000, 5'd0, 5'd0, 3'b000, 4'b0110, 1'b0, 7'b1100011}, 32'h0000000c);

        // beq x0, x0, -4 (should sign-extend)
        check_b_task(32'hfe000ee3, 32'hfffffffc);

        // beq x0, x0, -8
        check_b_task(32'hfe000ce3, 32'hfffffff8);

        // neither B-type nor I-type
        check_b_task(32'h00000033, 32'h00000000);

        tb_final_display("immediate_generator");

        $finish;
    end
endmodule
