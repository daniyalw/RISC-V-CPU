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
    integer i, num_tasks = 10, error_count = 0;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a = %h, b = %h, sel = %h | out = %h, expected = %h", a, b, sel, out, expected);
            error_count = error_count + 1;
        end
    endtask

    task testcase;
        begin
            for (i = 0; i < 2; i = i + 1) begin
                sel = i;
                #10;

                expected = sel ? b : a;

                if (out !== expected)
                    error_task();
            end
        end
    endtask

    initial begin
        $dumpfile("waves/mux2to1_32bit.vcd");
        $dumpvars(0, tb_mux2to1_32bit);

        $display("Running 32-bit 2:1 MUX..."); // should be no output unless error

        // will not test all cases because that's 2^65 cases (too many)
        // test case 1
        a = 32'h00000000;
        b = 32'hFFFFFFFF;
        testcase();

        // test case 2
        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        testcase();

        // test case 3
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        testcase();

        // test case 4
        a = 32'h12345678;
        b = 32'h87654321;
        testcase();

        // test case 5
        a = 32'h00000001; b = 32'h80000000;
        testcase();

        tb_final_display("mux2to1_32bit");

        $finish;
    end
endmodule
