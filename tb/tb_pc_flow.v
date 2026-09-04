module tb_pc_flow;
    reg clk = 0, reset = 0, enable = 1;
    integer num_tasks = 0, error_count = 0;
    wire [31:0] pc_next;
    wire [31:0] pc_current;

    always #5 clk = ~clk;

    program_counter pc (.clk(clk), .reset(reset), .enable(enable), .next_pc(pc_next), .pc(pc_current));
    pc_plus_4 pc4 (.pc(pc_current), .next_pc(pc_next));

    `include "tb/tb_final_display.vh"

    task check_task;
        input [31:0] expected_current;
        input [31:0] expected_next;

        begin
            num_tasks = num_tasks + 1;

            $display("pc_current = %h | pc_next = %h", pc_current, pc_next);

            if ((pc_next !== expected_next) || (pc_current !== expected_current)) begin
                $display("Error: pc_current = %h (should be %h), pc_next = %h (should be %h)", pc_current, expected_current, pc_next, expected_next);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/tb_pc_flow.vcd");
        $dumpvars(0, tb_pc_flow);

        $display("Running PC flow tests...");

        reset = 1;
        #1;
        reset = 0;
        #1;

        check_task(32'h00000000, 32'h00000004);

        @(posedge clk); #1;
        check_task(32'h00000004, 32'h00000008);

        @(posedge clk); #1;
        check_task(32'h00000008, 32'h0000000c);

        @(posedge clk); #1;
        check_task(32'h0000000c, 32'h00000010);

        tb_final_display("tb_pc_flow");

        $finish;
    end
endmodule
