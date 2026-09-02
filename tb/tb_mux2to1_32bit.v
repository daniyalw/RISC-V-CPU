module tb_mux2to1_32bit;
    reg [31:0] a;
    reg [31:0] b;
    reg sel;
    wire [31:0] out;

    mux2to1_32bit uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );

    reg [31:0] expected;
    integer error_count = 0;

    integer i;

    initial begin
        $dumpfile("waves/mux2to1_32bit.vcd");
        $dumpvars(0, tb_mux2to1_32bit);

        $display("OUTPUT"); // should be no output unless error

        // will not test all cases because that's 2^65 cases (too many)
        // test case 1
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'h00000000;
            b = 32'hFFFFFFFF; sel = i;
            #10;

            expected = sel ? b : a;

            if (out !== expected) begin
                $display("ERROR: a = %a, b = %b, sel = %b | out = %b, expected = %b", a, b, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 2
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'hFFFFFFFF; b = 32'h00000000; sel = i;
            #10;

            expected = sel ? b : a;

            if (out !== expected) begin
                $display("ERROR: a = %a, b = %b, sel = %b | out = %b, expected = %b", a, b, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 3
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'hAAAAAAAA; b = 32'h55555555; sel = i;
            #10;

            expected = sel ? b : a;

            if (out !== expected) begin
                $display("ERROR: a = %a, b = %b, sel = %b | out = %b, expected = %b", a, b, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 4
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'h12345678; b = 32'h87654321; sel = i;
            #10;

            expected = sel ? b : a;

            if (out !== expected) begin
                $display("ERROR: a = %a, b = %b, sel = %b | out = %b, expected = %b", a, b, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 5
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'h00000001; b = 32'h80000000; sel = i;
            #10;

            expected = sel ? b : a;

            if (out !== expected) begin
                $display("ERROR: a = %a, b = %b, sel = %b | out = %b, expected = %b", a, b, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        $display("ERROR COUNT: %0d", error_count);

        if (error_count == 0)
            $display("TESTBENCH PASSED");

        $finish;
    end
endmodule
