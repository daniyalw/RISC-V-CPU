module tb_alu_4bit;
    reg [3:0] a;
    reg [3:0] b;
    reg [2:0] op;
    wire [3:0] result;
    wire zero;
    wire cout;

    alu_4bit uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .zero(zero),
        .cout(cout)
    );

    integer i; // used in for-loop
    reg [3:0] expected_result;
    reg expected_zero;
    reg expected_cout;
    integer error_count = 0;

    initial begin
        $dumpfile("waves/alu_4bit.vcd");
        $dumpvars(0, tb_alu_4bit);

        $display("OUTPUT");

        for (i = 0; i < 2048; i = i + 1) begin
            {op, b, a} = i[10:0];
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
                expected_result = 4'b0000;
                expected_cout = 0;
            end

            expected_zero = (expected_result == 4'b0000);

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

        $display("==============================================================\nERROR COUNT: %0d", error_count);

        if (error_count == 0)
            $display("TESTBENCH PASSED");

        $finish;
    end
endmodule
