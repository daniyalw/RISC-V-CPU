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
        check_task({12'd5, 5'd0, 3'b000, 5'd1, 7'b0010011});

        // test 2
        address = 32'd4;
        check_task({12'd0, 5'd1, 3'b000, 5'd2, 7'b0010011});

        // test 3
        address = 32'd8;
        check_task({7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011});

        // test 4
        address = 32'd12;
        check_task({12'd0, 5'd3, 3'b000, 5'd4, 7'b0010011});

        tb_final_display("instruction_memory");

        $finish;
    end
endmodule
