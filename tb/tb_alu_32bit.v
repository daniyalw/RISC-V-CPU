module tb_alu_32bit;
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] op;
    wire [31:0] result;
    wire zero;
    wire cout;

    alu_32bit uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .cout(cout)
    );

    integer i; // used in for-loop
    reg [31:0] expected_result;
    reg expected_zero;
    reg expected_cout;
    integer error_count = 0, num_tasks = 40; // 8 test cases  * 5 ops = 40 total test cases

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b (expected = %b), cout = %b (expected = %b)", a, b, op, result, expected_result, zero, expected_zero, cout, expected_cout);
            error_count = error_count + 1;
        end
    endtask

    task testcase;
        input invalid_ops_test;
        begin
            // `i < 5` because we have 5 operations: ADD, SUB, AND, OR, XOR
            for (i = 0; i < 5; i = i + 1) begin

                if (invalid_ops_test == 1)
                    op = ((i == 2) ? 3'b110 : 3'b101);
                else
                    op = i;

                #10;

                // verify correctness
                if (op == 3'b000)
                    {expected_cout, expected_result} = a + b;
                else if (op == 3'b001) begin
                    expected_result = a + ~b + 1;
                    expected_cout = a >= b;
                end else if (op == 3'b010) begin
                    expected_result = a & b;
                    expected_cout = 0;
                end else if (op == 3'b011) begin
                    expected_result = a | b;
                    expected_cout = 0;
                end else if (op == 3'b100) begin
                    expected_result = a ^ b;
                    expected_cout = 0;
                end else begin
                    expected_result = {32{1'b0}};
                    expected_cout = 0;
                end

                expected_zero = (expected_result == {32{1'b0}});

                if ((cout !== expected_cout) || (result !== expected_result) || (zero !== expected_zero))
                    error_task();
            end
        end
    endtask

    initial begin
        $dumpfile("waves/alu_32bit.vcd");
        $dumpvars(0, tb_alu_32bit);

        $display("Running 32-bit ALU...");

        // test case 1
        a = 32'h00000000; b = 32'h00000000;
        testcase(0);

        // test case 2
        a = 32'h00000003; b = 32'h00000005;
        testcase(0);

        // test case 3
        a = 32'hFFFFFFFF; b = 32'h00000001;
        testcase(0);

        // test case 4
        a = 32'hAAAAAAAA; b = 32'hFFFFFFFF;
        testcase(0);

        // test case 5
        a = 32'h12345678; b = 32'h87654321;
        testcase(0);

        // test case 6
        a = 32'h12345678; b = 32'h00FF00FF;
        testcase(0);

        // invalid ops test cases
        // test case 7
        a = 32'h12345678; b = 32'h00FF00FF;
        testcase(1);

        // test case 8
        a = 32'hAAAAAAAA; b = 32'hFFFFFFFF;
        testcase(1);

        tb_final_display("alu_32bit");

        $finish;
    end
endmodule
