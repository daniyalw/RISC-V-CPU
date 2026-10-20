module tb_instruction_memory;
    reg [31:0] address;
    wire [31:0] instruction;

    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    instruction_memory uut (.address(address), .instruction(instruction));

    task check_task;
        input [31:0] expected_instruction;

        begin
            num_tasks = num_tasks + 1;

            #1;

            if (instruction !== expected_instruction) begin
                $display("Error: address = %h | instruction = %h (expected = %h)", address, instruction, expected_instruction);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/instruction_memory.vcd");
        $dumpvars(0, tb_instruction_memory);

        $display("Running instruction memory tests...");

        // test 1
        address = 32'd0;
        check_task(32'hffb00093);

        // test 2
        address = 32'd4;
        check_task(32'h00300113);

        // test 3
        address = 32'd8;
        check_task(32'hfff00193);

        // test 4
        address = 32'd12;
        check_task(32'h00100213);

        // test 5
        address = 32'd16;
        check_task(32'h0020a2b3);

        // test 6
        address = 32'd20;
        check_task(32'h00112333);

        // test 7
        address = 32'd24;
        check_task(32'h0041b3b3);

        // test 8
        address = 32'd28;
        check_task(32'h00323433);

        // test 9
        address = 32'd32;
        check_task(32'h0000a493);

        // test 10
        address = 32'd36;
        check_task(32'h00012513);

        // test 11
        address = 32'd40;
        check_task(32'h0011b593);

        // test 12
        address = 32'd44;
        check_task(32'hfff23613);

        tb_final_display("instruction_memory");

        $finish;
    end
endmodule
