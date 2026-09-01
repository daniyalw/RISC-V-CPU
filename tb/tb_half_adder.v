module tb_half_adder;
    reg a;
    reg b;
    wire sum;
    wire carry;

    half_adder uut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    integer i;
    reg expected_sum;
    reg expected_carry;

    initial begin
        $dumpfile("waves/half_adder.vcd");
        $dumpvars(0, tb_half_adder);

        $display("a\tb\t|\tsum\tcarry");
        $display("=====================================");

        // 4 cases
        for (i = 0; i < 4; i = i + 1) begin
            {b, a} = i[1:0];
            #10;
            $display("%b\t%b\t|\t%b\t%b", a, b, sum, carry);

            expected_sum = a ^ b;
            expected_carry = a & b;

            if (sum !== expected_sum)
                $display("SUM ERROR");

            if (carry !== expected_carry)
                $display("CARRY ERROR");
        end

        $finish;
    end
endmodule
