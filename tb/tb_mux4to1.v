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

    integer i, num_tasks = 64, error_count = 0;
    reg expected;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a = %b, b = %b, c = %b, d = %b | sel = %b | out = %b (expected = %b)", a, b, c, d, sel, out, expected);
            error_count = error_count + 1;
        end
    endtask

    initial begin
        $dumpfile("waves/mux4to1.vcd");
        $dumpvars(0, tb_mux4to1);

        $display("Running 1-bit 4:1 MUX...");

        // 64 cases
        for (i = 0; i < num_tasks; i = i + 1) begin
            {sel[1:0], d, c, b, a} = i[5:0];
            #10;

            // verify correctness
            expected = (sel == 2'b00) ? a :
                (sel == 2'b01) ? b :
                (sel == 2'b10) ? c :
                    d;

            if (out !== expected)
                error_task();
        end

        tb_final_display("mux4to1");

        $finish;
    end
endmodule
