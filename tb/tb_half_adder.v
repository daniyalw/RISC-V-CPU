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
    integer num_tasks = 4, error_count = 0;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a = %b, b = %b | sum = %b (expected = %b), carry = %b", a, b, sum, expected_sum, carry, expected_carry);
            error_count = error_count + 1;
        end
    endtask

    initial begin
        $dumpfile("waves/half_adder.vcd");
        $dumpvars(0, tb_half_adder);

        $display("Running half adder...");

        // 4 cases
        for (i = 0; i < num_tasks; i = i + 1) begin
            {b, a} = i[1:0];
            #10;

            expected_sum = a ^ b;
            expected_carry = a & b;

            if ((sum !== expected_sum) || (carry !== expected_carry))
                error_task();
        end

        tb_final_display("half_adder");

        $finish;
    end
endmodule
