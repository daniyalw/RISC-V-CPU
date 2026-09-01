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

    initial begin
        $dumpfile("waves/full_adder.vcd");
        $dumpvars(0, tb_full_adder);

        $display("a\tb\tcin\t|\tsum\tcout");
        $display("=======================================================");

        for (i = 0; i < 8; i = i + 1) begin
            {cin, b, a} = i[2:0];
            #10;
            $display("%b\t%b\t%b\t|\t%b\t%b", a, b, cin, sum, cout);

            {expected_cout, expected_sum} = a + b + cin; // verification

            if (sum !== expected_sum)
                $display("SUM ERROR"); // since the above line is printed anyway (printing a, b, cin, sum, cout) I don't need to re-print in error msg

            if (cout !== expected_cout)
                $display("COUT ERROR");

        end

        $finish;
    end
endmodule
