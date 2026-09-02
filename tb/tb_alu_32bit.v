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
    integer error_count = 0;

    initial begin
        $dumpfile("waves/alu_32bit.vcd");
        $dumpvars(0, tb_alu_32bit);

        // test case 1
        for (i = 0; i < 5; i = i + 1) begin
            a = 32'h00000000; b = 32'h00000000;

            if (i == 0) // add
                op = 3'b000;
            else if (i == 1) // subtract
                op = 3'b001;
            else if (i == 2) // and
                op = 3'b010;
            else if (i == 3) // or
                op = 3'b011;
            else if (i == 4) // xor
                op = 3'b100;
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

            if (result !== expected_result) begin
                $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b, cout = %b", a, b, op, result, expected_result, zero, cout);
                error_count = error_count + 1;
            end

            if (cout !== expected_cout) begin
                $display("COUT ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b, cout = %b (expected = %b)", a, b, op, result, zero, cout, expected_cout);
                error_count = error_count + 1;
            end

            if (zero !== expected_zero) begin
                $display("ZERO ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b (expected = %b), cout = %b", a, b, op, result, zero, expected_zero, cout);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 2
        for (i = 0; i < 5; i = i + 1) begin
            a = 32'h00000003; b = 32'h00000005;

            if (i == 0) // add
                op = 3'b000;
            else if (i == 1) // subtract
                op = 3'b001;
            else if (i == 2) // and
                op = 3'b010;
            else if (i == 3) // or
                op = 3'b011;
            else if (i == 4) // xor
                op = 3'b100;
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

            if (result !== expected_result) begin
                $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b, cout = %b", a, b, op, result, expected_result, zero, cout);
                error_count = error_count + 1;
            end

            if (cout !== expected_cout) begin
                $display("COUT ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b, cout = %b (expected = %b)", a, b, op, result, zero, cout, expected_cout);
                error_count = error_count + 1;
            end

            if (zero !== expected_zero) begin
                $display("ZERO ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b (expected = %b), cout = %b", a, b, op, result, zero, expected_zero, cout);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 3
        for (i = 0; i < 5; i = i + 1) begin
            a = 32'hFFFFFFFF; b = 32'h00000001;

            if (i == 0) // add
                op = 3'b000;
            else if (i == 1) // subtract
                op = 3'b001;
            else if (i == 2) // and
                op = 3'b010;
            else if (i == 3) // or
                op = 3'b011;
            else if (i == 4) // xor
                op = 3'b100;
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

            if (result !== expected_result) begin
                $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b, cout = %b", a, b, op, result, expected_result, zero, cout);
                error_count = error_count + 1;
            end

            if (cout !== expected_cout) begin
                $display("COUT ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b, cout = %b (expected = %b)", a, b, op, result, zero, cout, expected_cout);
                error_count = error_count + 1;
            end

            if (zero !== expected_zero) begin
                $display("ZERO ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b (expected = %b), cout = %b", a, b, op, result, zero, expected_zero, cout);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 4
        for (i = 0; i < 5; i = i + 1) begin
            a = 32'hAAAAAAAA; b = 32'hFFFFFFFF;

            if (i == 0) // add
                op = 3'b000;
            else if (i == 1) // subtract
                op = 3'b001;
            else if (i == 2) // and
                op = 3'b010;
            else if (i == 3) // or
                op = 3'b011;
            else if (i == 4) // xor
                op = 3'b100;
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

            if (result !== expected_result) begin
                $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b, cout = %b", a, b, op, result, expected_result, zero, cout);
                error_count = error_count + 1;
            end

            if (cout !== expected_cout) begin
                $display("COUT ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b, cout = %b (expected = %b)", a, b, op, result, zero, cout, expected_cout);
                error_count = error_count + 1;
            end

            if (zero !== expected_zero) begin
                $display("ZERO ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b (expected = %b), cout = %b", a, b, op, result, zero, expected_zero, cout);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 5
        for (i = 0; i < 5; i = i + 1) begin
            a = 32'h12345678; b = 32'h87654321;

            if (i == 0) // add
                op = 3'b000;
            else if (i == 1) // subtract
                op = 3'b001;
            else if (i == 2) // and
                op = 3'b010;
            else if (i == 3) // or
                op = 3'b011;
            else if (i == 4) // xor
                op = 3'b100;
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

            if (result !== expected_result) begin
                $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b, cout = %b", a, b, op, result, expected_result, zero, cout);
                error_count = error_count + 1;
            end

            if (cout !== expected_cout) begin
                $display("COUT ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b, cout = %b (expected = %b)", a, b, op, result, zero, cout, expected_cout);
                error_count = error_count + 1;
            end

            if (zero !== expected_zero) begin
                $display("ZERO ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b (expected = %b), cout = %b", a, b, op, result, zero, expected_zero, cout);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 6
        for (i = 0; i < 5; i = i + 1) begin
            a = 32'h12345678; b = 32'h00FF00FF;

            if (i == 0) // add
                op = 3'b000;
            else if (i == 1) // subtract
                op = 3'b001;
            else if (i == 2) // and
                op = 3'b010;
            else if (i == 3) // or
                op = 3'b011;
            else if (i == 4) // xor
                op = 3'b100;
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

            if (result !== expected_result) begin
                $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b, cout = %b", a, b, op, result, expected_result, zero, cout);
                error_count = error_count + 1;
            end

            if (cout !== expected_cout) begin
                $display("COUT ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b, cout = %b (expected = %b)", a, b, op, result, zero, cout, expected_cout);
                error_count = error_count + 1;
            end

            if (zero !== expected_zero) begin
                $display("ZERO ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b (expected = %b), cout = %b", a, b, op, result, zero, expected_zero, cout);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // invalid ops test cases
        // test case 7
        for (i = 0; i < 5; i = i + 1) begin
            a = 32'h12345678; b = 32'h00FF00FF;

            op = 3'b101;
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

            if (result !== expected_result) begin
                $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b, cout = %b", a, b, op, result, expected_result, zero, cout);
                error_count = error_count + 1;
            end

            if (cout !== expected_cout) begin
                $display("COUT ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b, cout = %b (expected = %b)", a, b, op, result, zero, cout, expected_cout);
                error_count = error_count + 1;
            end

            if (zero !== expected_zero) begin
                $display("ZERO ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b (expected = %b), cout = %b", a, b, op, result, zero, expected_zero, cout);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 8
        for (i = 0; i < 5; i = i + 1) begin
            a = 32'h12345678; b = 32'h00FF00FF;

            op = 3'b110;
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

            if (result !== expected_result) begin
                $display("ERROR: a = %b, b = %b | op = %b | result = %b (expected = %b), zero = %b, cout = %b", a, b, op, result, expected_result, zero, cout);
                error_count = error_count + 1;
            end

            if (cout !== expected_cout) begin
                $display("COUT ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b, cout = %b (expected = %b)", a, b, op, result, zero, cout, expected_cout);
                error_count = error_count + 1;
            end

            if (zero !== expected_zero) begin
                $display("ZERO ERROR: a = %b, b = %b | op = %b | result = %b, zero = %b (expected = %b), cout = %b", a, b, op, result, zero, expected_zero, cout);
                error_count = error_count + 1;
            end
        end

        i = 0;

        $display("==============================================================\nERROR COUNT: %0d", error_count);

        if (error_count == 0)
            $display("TESTBENCH PASSED");

        $finish;
    end
endmodule
