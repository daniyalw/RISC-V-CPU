module tb_mux2to1;
    reg a;
    reg b;
    reg sel;
    wire out;

    mux2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );

    initial begin
        $dumpfile("waves/mux2to1.vcd");
        $dumpvars(0, tb_mux2to1);

        $display("a\tb\tsel\t|\tout");
        $display("=========================");

        a = 0; b = 0; sel = 0;
        #10;

        $display("%b\t%b\t%b\t|\t%b", a, b, sel, out);

        a = 0; b = 1; sel = 0;
        #10;

        $display("%b\t%b\t%b\t|\t%b", a, b, sel, out);

        a = 1; b = 0; sel = 0;
        #10;

        $display("%b\t%b\t%b\t|\t%b", a, b, sel, out);

        a = 1; b = 1; sel = 0;
        #10;

        $display("%b\t%b\t%b\t|\t%b", a, b, sel, out);

        a = 0; b = 0; sel = 1;
        #10;

        $display("%b\t%b\t%b\t|\t%b", a, b, sel, out);

        a = 0; b = 1; sel = 1;
        #10;

        $display("%b\t%b\t%b\t|\t%b", a, b, sel, out);

        a = 1; b = 0; sel = 1;
        #10;

        $display("%b\t%b\t%b\t|\t%b", a, b, sel, out);

        a = 1; b = 1; sel = 1;
        #10;

        $display("%b\t%b\t%b\t|\t%b", a, b, sel, out);

        $finish;
    end
endmodule
