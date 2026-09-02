module tb_full_adder;
    reg a;
    reg b;
    reg cin;
    wire sum;
    wire cout;

    full_adder uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i;
    reg expected_sum;
    reg expected_cout;
    integer num_tasks = 8, error_count = 0;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("Error: a = %b, b = %b, cin = %b | sum = %b (expected = %b), cout = %b (expected = %b)", a, b, cin, sum, expected_sum, cout, expected_cout);
            error_count = error_count + 1;
        end
    endtask

    initial begin
        $dumpfile("waves/full_adder.vcd");
        $dumpvars(0, tb_full_adder);

        $display("Running 1-bit full adder...");

        for (i = 0; i < num_tasks; i = i + 1) begin
            {cin, b, a} = i[2:0];
            #10;

            {expected_cout, expected_sum} = a + b + cin; // verification

            if ((sum !== expected_sum) || (cout !== expected_cout))
                error_task();
        end

        tb_final_display("full_adder");

        $finish;
    end
endmodule
