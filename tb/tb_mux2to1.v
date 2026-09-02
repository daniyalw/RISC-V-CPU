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

    integer i, num_tasks = 8, error_count = 0;
    reg expected_out;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a = %b, b = %b | sel = %b | out = %b (expected = %b)", a, b, sel, out, expected_out);
        end
    endtask

    initial begin
        $dumpfile("waves/mux2to1.vcd");
        $dumpvars(0, tb_mux2to1);

        $display("Running 1-bit 2:1 MUX...");

        for (i = 0; i < num_tasks; i = i + 1) begin
            {sel, b, a} = i[2:0];
            #10;

            expected_out = sel ? b : a;

            if (out !== expected_out)
                error_task();
        end

        tb_final_display("mux2to1");

        $finish;
    end
endmodule
