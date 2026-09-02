module tb_mux2to1_4bit;
    reg [3:0] a;
    reg [3:0] b;
    reg sel;
    wire [3:0] out;

    mux2to1_4bit uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );

    integer i;
    reg [3:0] expected;

    initial begin
        $dumpfile("waves/mux2to1_4bit.vcd");
        $dumpvars(0, tb_mux2to1_4bit);

        $display("OUTPUT"); // should be no output unless error

        for (i = 0; i < 512; i = i + 1) begin
            {sel, b, a} = i[8:0];
            #10;

            expected = (sel == 0) ? a : b;

            if (out !== expected)
                $display("ERROR: a: %b; b: %b | sel: %b | out: %b", a, b, sel, out);
        end

        $finish;
    end
endmodule
