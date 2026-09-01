module tb_ripple_carry_4bit;
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] sum;
    wire cout;

    ripple_carry_4bit uut (.a(a), .b(b), .cin(cin), .sum(sum), .cout(cout));

    integer i;
    reg [3:0] expected_sum;
    reg expected_cout;

    initial begin
        $dumpfile("waves/ripple_carry_4bit.vcd");
        $dumpvars(0, tb_ripple_carry_4bit);

        $display("a\tb\tcin\t|\tsum\tcout");
        $display("=======================================================================");

        for (i = 0; i < 512; i = i + 1) begin
            {cin, b, a} = i[8:0];
            #10;
            $display("%b\t%b\t%b\t|\t%b\t%b", a, b, cin, sum, cout);

            {expected_cout, expected_sum} = a + b + cin;

            if (sum !== expected_sum)
                $display("ERROR SUM");

            if (cout !== expected_cout)
                $display("ERROR COUT");
        end

        $finish;
    end
endmodule
