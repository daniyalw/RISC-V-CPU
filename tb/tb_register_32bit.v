module tb_register_32bit;
    reg clk = 0, reset, enable;
    reg [31:0] d;
    wire [31:0] q;

    integer error_count = 0;
    integer num_tasks = 0;

    always #5 clk = ~clk; // this creates a clock signal with a period of 10, five sim units = high, five low, repeat

    register_32bit uut (.clk(clk), .reset(reset), .enable(enable), .d(d), .q(q));

    `include "tb/tb_final_display.vh"

    task check_task;
        input [31:0] expected;
        begin
            num_tasks = num_tasks + 1;

            if (q !== expected) begin
                $display("Error: Task %0d | clk = %h, reset = %b, enable = %b | d = %h | q = %h (expected = %h)", num_tasks, clk, reset, enable, d, q, expected);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/register_32bit.vcd");
        $dumpvars(0, tb_register_32bit);

        $display("Running 32-bit register tests...");

        // initial values
        reset = 0;
        enable = 0;
        d = 32'h00000000;
        #2;

        // test case 1 - async reset
        reset = 1;
        #1;
        check_task(32'h00000000);
        reset = 0;
        #5;

        // test case 2 - test load on clock edge
        d = 32'h12345678;
        enable = 1;
        @(posedge clk);
        #1; // do one time unit for sim so check_task() doesn't operate right at rising clock edge because it'll fail
        check_task(32'h12345678);

        // test case 3 - test q holding when clock changes
        #6;
        check_task(32'h12345678);

        // test case 4 - test load when enable=0
        enable = 0;
        d = 32'hDEADBEEF;
        @(posedge clk);
        #1;
        check_task(32'h12345678);

        // test case 5 - test q holding when clock changes with different d
        d = 32'h00000000;
        #1;
        check_task(32'h12345678);

        // test case 6 - test reset
        reset = 1;
        #1;
        check_task(32'h00000000);

        tb_final_display("register_32bit");

        $finish;
    end
endmodule
