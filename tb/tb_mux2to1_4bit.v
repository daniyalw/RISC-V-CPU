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
    integer num_tasks = 512, error_count = 0;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a: %b; b: %b | sel: %b | out: %b, expected = %b", a, b, sel, out, expected);
            error_count = error_count + 1;
        end
    endtask

    initial begin
        $dumpfile("waves/mux2to1_4bit.vcd");
        $dumpvars(0, tb_mux2to1_4bit);

        $display("Running 4-bit 2:1 MUX...");

        for (i = 0; i < num_tasks; i = i + 1) begin
            {sel, b, a} = i[8:0];
            #10;

            expected = (sel == 0) ? a : b;

            if (out !== expected)
                error_task();
        end

        tb_final_display("mux2to1_4bit");

        $finish;
    end
endmodule
