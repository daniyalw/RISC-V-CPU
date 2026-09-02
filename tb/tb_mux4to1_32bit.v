module tb_mux4to1_32bit;
    reg [31:0] a, b, c, d;
    reg [1:0] sel;
    wire [31:0] out;

    mux4to1_32bit uut (.a(a), .b(b), .c(c), .d(d), .sel(sel), .out(out));

    reg [31:0] expected;
    integer error_count = 0;
    integer i;

    initial begin
        $dumpfile("waves/mux4to1_32bit.vcd");
        $dumpvars(0, tb_mux4to1_32bit);

        // do not test all cases, that's far too many
        // test case 1
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'h00000000;
            b = 32'hFFFFFFFF;
            c = 32'hAAAAAAAA;
            d = 32'h55555555;
            sel = i;
            #10;

            expected = (sel == 2'b00) ? a :
                    (sel == 2'b01) ? b :
                    (sel == 2'b10) ? c :
                    d;

            if (out !== expected) begin
                $display("ERROR: a = %h, b = %h, c = %h, d = %h | sel = %h | out = %h, expected = %h", a, b, c, d, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 2
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'h12345678;
            b = 32'h87654321;
            c = 32'hDEADBEEF;
            d = 32'hCAFEBABE;
            sel = i;
            #10;

            expected = (sel == 2'b00) ? a :
                    (sel == 2'b01) ? b :
                    (sel == 2'b10) ? c :
                    d;

            if (out !== expected) begin
                $display("ERROR: a = %h, b = %h, c = %h, d = %h | sel = %h | out = %h, expected = %h", a, b, c, d, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 3
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'h00000001;
            b = 32'h80000000;
            c = 32'h00008000;
            d = 32'h00010000;
            sel = i;
            #10;

            expected = (sel == 2'b00) ? a :
                    (sel == 2'b01) ? b :
                    (sel == 2'b10) ? c :
                    d;

            if (out !== expected) begin
                $display("ERROR: a = %h, b = %h, c = %h, d = %h | sel = %h | out = %h, expected = %h", a, b, c, d, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 4
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'h00000005;
            b = 32'h0000000A;
            c = 32'h0000000F;
            d = 32'h00000010;
            sel = i;
            #10;

            expected = (sel == 2'b00) ? a :
                    (sel == 2'b01) ? b :
                    (sel == 2'b10) ? c :
                    d;

            if (out !== expected) begin
                $display("ERROR: a = %h, b = %h, c = %h, d = %h | sel = %h | out = %h, expected = %h", a, b, c, d, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        i = 0;

        // test case 5
        for (i = 0; i < 2; i = i + 1) begin
            a = 32'h000000FF;
            b = 32'h0000FF00;
            c = 32'h00FF0000;
            d = 32'hFF000000;
            sel = i;
            #10;

            expected = (sel == 2'b00) ? a :
                    (sel == 2'b01) ? b :
                    (sel == 2'b10) ? c :
                    d;

            if (out !== expected) begin
                $display("ERROR: a = %h, b = %h, c = %h, d = %h | sel = %h | out = %h, expected = %h", a, b, c, d, sel, out, expected);
                error_count = error_count + 1;
            end
        end

        $display("ERROR COUNT: %0d", error_count);

        if (error_count == 0)
            $display("TESTBENCH PASSED");

        $finish;
    end
endmodule
