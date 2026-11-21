module tb_alu_32bit;
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] op;
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
    integer error_count = 0, num_tasks = 0;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("Error: test %0d: a = %h, b = %h | op = %b | result = %h (expected = %h), zero = %b (expected = %b), cout = %b (expected = %b)", num_tasks, a, b, op, result, expected_result, zero, expected_zero, cout, expected_cout);
            error_count = error_count + 1;
        end
    endtask

    task testcase;
        begin
            num_tasks = num_tasks + 1;

            // `i < 10` because we have 10 operations: ADD(I), SUB, AND(I), OR(I), XOR(I), SLT(I), SLT(I)U
            for (i = 0; i < 10; i = i + 1) begin
                op = i;

                #10;

                // verify correctness
                if (op == 4'b0000) // ADD/ADDI
                    {expected_cout, expected_result} = a + b;
                else if (op == 4'b0001) begin // SUB
                    expected_result = a + ~b + 1;
                    expected_cout = a >= b;
                end else if (op == 4'b0010) begin // AND/ANDI
                    expected_result = a & b;
                    expected_cout = 0;
                end else if (op == 4'b0011) begin // OR/ORI
                    expected_result = a | b;
                    expected_cout = 0;
                end else if (op == 4'b0100) begin // XOR/XORI
                    expected_result = a ^ b;
                    expected_cout = 0;
                end else if (op == 4'b0101) begin // SLT/SLTI
                    expected_result = $signed(a) < $signed(b);
                    expected_cout = 0;
                end else if (op == 4'b0110) begin // SLTU/SLTIU
                    expected_result = $unsigned(a) < $unsigned(b);
                    expected_cout = 0;
                end else if (op == 4'b0111) begin // SLL/SLLI
                    expected_result = a << b[4:0];
                    expected_cout = 0;
                end else if (op == 4'b1000) begin // SRL/SRLI
                    expected_result = a >> b[4:0];
                    expected_cout = 0;
                end else if (op == 4'b1001) begin // SRA/SRAI
                    expected_result = $signed(a) >>> b[4:0];
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
        a = 32'h00000005; b = 32'h00000003;
        testcase();

        // test case 2
        a = 32'h0000000A; b = 32'h00000002;
        testcase();

        // test case 3
        a = 32'h000000FF; b = 32'h00000001;
        testcase();

        // test case 4
        a = 32'h00001000; b = 32'h00000100;
        testcase();

        // test case 5
        a = 32'h12345678; b = 32'h87654321;
        testcase();

        // test case 6
        a = 32'h00000000; b = 32'h00000000;
        testcase();

        // test case 7
        a = 32'hFFFFFFFF; b = 32'h00000001;
        testcase();

        // test case 8
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF;
        testcase();

        // test case 9
        a = 32'h80000000; b = 32'h00000001;
        testcase();

        // test case 10
        a = 32'h7FFFFFFF; b = 32'h00000001;
        testcase();

        // test case 11
        a = 32'hAAAAAAAA; b = 32'h55555555;
        testcase();

        // test case 12
        a = 32'hFFFFFFFF; b = 32'h0F0F0F0F;
        testcase();

        // test case 13
        a = 32'hF0F0F0F0; b = 32'h00FF00FF;
        testcase();

        // test case 14
        a = 32'h11111111; b = 32'h88888888;
        testcase();

        // test case 15
        a = 32'hDEADBEEF; b = 32'hCAFEBABE;
        testcase();

        // test case 16
        a = 32'hFFFFFFFE; b = 32'h00000002;
        testcase();

        // test case 17
        a = 32'hFFFFFFF0; b = 32'h00000010;
        testcase();

        // test case 18
        a = 32'h80000000; b = 32'hFFFFFFFF;
        testcase();

        // test case 19
        a = 32'h7FFFFFFF; b = 32'hFFFFFFFF;
        testcase();

        // test case 20
        a = 32'hFFFF0000; b = 32'h00010000;
        testcase();

        // test case 21
        a = 32'h00000001; b = 32'h00000001;
        testcase();

        // test case 22
        a = 32'h80000000; b = 32'h00000004;
        testcase();

        // test case 23
        a = 32'h12345678; b = 32'h00000008;
        testcase();

        // test case 24
        a = 32'hFFFFFFFF; b = 32'h00000010;
        testcase();

        // test case 25
        a = 32'h0000000F; b = 32'h0000001F;
        testcase();

        // test case 26
        a = 32'hA5A5A5A5; b = 32'h5A5A5A5A;
        testcase();

        // test case 27
        a = 32'h13579BDF; b = 32'h2468ACE0;
        testcase();

        // test case 28
        a = 32'hFACE1234; b = 32'hBEEF5678;
        testcase();

        // test case 29
        a = 32'h01020304; b = 32'h10203040;
        testcase();

        // test case 30
        a = 32'hFEDCBA98; b = 32'h76543210;
        testcase();

        tb_final_display("alu_32bit");
        $display("NOTE: each test case has been tested on all 10 operations.");

        $finish;
    end
endmodule
