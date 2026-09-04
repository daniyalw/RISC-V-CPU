module tb_pc_plus_4;
    reg [31:0] pc;
    wire [31:0] next_pc;

    pc_plus_4 uut (.pc(pc), .next_pc(next_pc));

    integer error_count = 0, num_tasks = 0;

    `include "tb/tb_final_display.vh"

    task testcase;
        input [31:0] expected;
        begin
            num_tasks = num_tasks + 1;

            if (next_pc !== expected) begin
                $display("Error: %h + 4 = %h (expected = %h)", pc, next_pc, expected);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/pc_plus_4.vcd");
        $dumpvars(0, tb_pc_plus_4);

        $display("Running PC+4 tests...");

        // test case 1
        pc = 32'h00000000;
        #10;
        testcase(32'h00000004);

        // test case 2
        pc = 32'h00000004;
        #10;
        testcase(32'h00000008);

        // test case 3
        pc = 32'h00000008;
        #10
        testcase(32'h0000000C);

        // test case 4
        pc = 32'hFFFFFFFC;
        #10
        testcase(32'h00000000);

        tb_final_display("pc_plus_4");

        $finish;
    end
endmodule
