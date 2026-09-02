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

    integer i, num_tasks = 65536, error_count = 0;
    reg [3:0] expected;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a: %b; b: %b; c: %b; d: %b | sel: %b | out: %b, expected = %b", a, b, c, d, sel, out, expected);
            error_count = error_count + 1;
        end
    endtask

    initial begin
        $dumpfile("waves/mux4to1_4bit.vcd");
        $dumpvars(0, tb_mux4to1_4bit);

        $display("Running 4-bit 4:1 MUX..."); // should output nothing if no error

        for (i = 0; i < num_tasks; i = i + 1) begin
            {sel[1:0], d, c, b, a} = i[15:0];
            #10;

            // verify correctness
            expected = (sel == 2'b00) ? a :
                (sel == 2'b01) ? b :
                (sel == 2'b10) ? c :
                    d;

            if (out !== expected)
                error_task();
        end

        tb_final_display("mux4to1_4bit");

        $finish;
    end
endmodule
