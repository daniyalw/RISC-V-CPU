module tb_add_sub_4bit;
    reg [3:0] a;
    reg [3:0] b;
    reg sub;
    wire [3:0] result;
    wire cout;

    add_sub_4bit uut (.a(a), .b(b), .sub(sub), .result(result), .cout(cout));

    integer i;
    reg [3:0] expected_result;
    reg expected_cout;

    initial begin
        $dumpfile("waves/add_sub_4bit.vcd");
        $dumpvars(0, tb_add_sub_4bit);

        for (i = 0; i < 512; i = i + 1) begin
            {sub, b, a} = i[8:0];
            #10;
            if (sub == 0) begin
                $display("%b + %b = %b, cout: %b", a, b, result, cout);

                {expected_cout, expected_result} = a + b;

                if (result !== expected_result)
                    $display("RESULT ERROR");

                if (cout !== expected_cout)
                    $display("COUT ERROR");
            end

            if (sub == 1) begin
                $display("%b - %b = %b, cout: %b", a, b, result, cout);

                expected_result = a + ~b + 1;
                expected_cout = a >= b;

                if (result !== expected_result)
                    $display("RESULT ERROR");

                if (cout !== expected_cout)
                    $display("COUT ERROR");
            end
        end

        $finish;
    end
endmodule
