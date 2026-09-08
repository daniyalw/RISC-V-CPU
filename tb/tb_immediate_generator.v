module tb_immediate_generator;
    reg [31:0] instruction;
    wire [31:0] immediate;

    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    immediate_generator uut (.instruction(instruction), .immediate(immediate));

    task check_task;
        input [11:0] twelve_bit_immediate;
        input [31:0] expected;

        begin
            num_tasks = num_tasks + 1;

            instruction = {twelve_bit_immediate, 5'd0, 3'b000, 5'd1, 7'b0010011};

            #1; // 1 time unit

            if (immediate !== expected) begin
                $display("Error: instruction: %h | immediate = %h (expected = %h)", instruction, immediate, expected);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/immediate_generator.vcd");
        $dumpvars(0, tb_immediate_generator);

        $display("Running immediate generator tests...");

        // I-type tests
        // test 1
        check_task(12'h000, 32'h00000000);

        // test 2
        check_task(12'h001, 32'h00000001);

        // test 3
        check_task(12'h005, 32'h00000005);

        // test 4
        check_task(12'h7FF, 32'h000007FF);

        // test 5
        check_task(12'h800, 32'hFFFFF800);

        // test 6
        check_task(12'hFFF, 32'hFFFFFFFF);

        // test 7
        check_task(12'hFF0, 32'hFFFFFFF0);

        tb_final_display("immediate_generator");

        $finish;
    end
endmodule
