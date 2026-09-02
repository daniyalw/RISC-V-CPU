module tb_add_sub_4bit;
    reg [3:0] a;
    reg [3:0] b;
    reg sub;
    wire [3:0] result;
    wire cout;

    add_sub_4bit uut (.a(a), .b(b), .sub(sub), .result(result), .cout(cout));

    integer i, error_count = 0;
    reg [3:0] expected_result;
    reg expected_cout;
    integer num_tasks = 512;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: %b %s %b = %b, cout = %b, expected result = %b, expected cout = %b",
                     a, (~sub) ? "+" : "-", b, result, cout, expected_result, expected_cout);
            error_count = error_count + 1;
        end
    endtask

    initial begin
        $dumpfile("waves/add_sub_4bit.vcd");
        $dumpvars(0, tb_add_sub_4bit);

        $display("Running 4-bit adder/subtracter module tests...");

        for (i = 0; i < num_tasks; i = i + 1) begin
            {sub, b, a} = i[8:0];
            #10;

            if (sub == 0)
                {expected_cout, expected_result} = a + b;

            if (sub == 1) begin
                expected_result = a + ~b + 1;
                expected_cout = a >= b;
            end

            if (result !== expected_result)
                error_task();

            if (cout !== expected_cout)
                error_task();
        end

        tb_final_display("add_sub_4bit");

        $finish;
    end
endmodule
