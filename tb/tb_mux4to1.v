module tb_mux4to1;
    reg a;
    reg b;
    reg c;
    reg d;
    reg [1:0] sel;
    wire out;

    mux4to1 uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .out(out)
    );

    integer i; // used in for-loop
    reg expected;

    initial begin
        $dumpfile("waves/mux4to1.vcd");
        $dumpvars(0, tb_mux4to1);

        $display("a\tb\tc\td\tsel\t|\tout");
        $display("=========================");

        // 64 cases
        for (i = 0; i < 64; i = i + 1) begin
            {sel[1:0], d, c, b, a} = i[5:0];
            #10;
            $display("%b\t%b\t%b\t%b\t%b\t|\t%b", a, b, c, d, sel, out);

            // verify correctness
            expected = (sel == 2'b00) ? a :
                (sel == 2'b01) ? b :
                (sel == 2'b10) ? c :
                    d;

            if (out !== expected)
                $display("ERROR");
        end

        $finish;
    end
endmodule
