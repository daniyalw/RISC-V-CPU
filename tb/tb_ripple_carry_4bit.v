module tb_ripple_carry_4bit;
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] sum;
    wire cout;

    ripple_carry_4bit uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i, num_tasks = 512, error_count = 0;
    reg [3:0] expected_sum;
    reg expected_cout;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a = %b, b = %b | cin = %b | sum = %b (expected = %b), cout = %b (expected = %b)", a, b, cin, sum, expected_sum, cout, expected_cout);
            error_count = error_count + 1;
        end
    endtask

    initial begin
        $dumpfile("waves/ripple_carry_4bit.vcd");
        $dumpvars(0, tb_ripple_carry_4bit);

        $display("Running 4-bit ripple carry adder...");

        for (i = 0; i < num_tasks; i = i + 1) begin
            {cin, b, a} = i[8:0];
            #10;

            {expected_cout, expected_sum} = a + b + cin;

            if ((sum !== expected_sum) || (cout !== expected_cout))
                error_task();
        end

        tb_final_display("ripple_carry_4bit");

        $finish;
    end
endmodule
