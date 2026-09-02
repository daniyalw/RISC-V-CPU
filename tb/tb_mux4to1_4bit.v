module tb_mux4to1_4bit;
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [1:0] sel;
    wire [3:0] out;

    mux4to1_4bit uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .out(out)
    );

    integer i; // used in for-loop
    reg [3:0] expected;

    initial begin
        $dumpfile("waves/mux4to1_4bit.vcd");
        $dumpvars(0, tb_mux4to1_4bit);

        $display("OUTPUT"); // should output nothing if no error

        for (i = 0; i < 65536; i = i + 1) begin
            {sel[1:0], d, c, b, a} = i[15:0];
            #10;

            // verify correctness
            expected = (sel == 2'b00) ? a :
                (sel == 2'b01) ? b :
                (sel == 2'b10) ? c :
                    d;

            if (out !== expected)
                $display("ERROR: a: %b; b: %b; c: %b; d: %b | sel: %b | out: %b", a, b, c, d, sel, out);
        end

        $finish;
    end
endmodule
