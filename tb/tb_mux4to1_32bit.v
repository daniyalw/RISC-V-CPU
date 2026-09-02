module tb_mux4to1_32bit;
    reg [31:0] a, b, c, d;
    reg [1:0] sel;
    wire [31:0] out;

    mux4to1_32bit uut (.a(a), .b(b), .c(c), .d(d), .sel(sel), .out(out));

    reg [31:0] expected;
    integer i, num_tasks = 20, error_count = 0;

    `include "tb/tb_final_display.vh"

    task error_task;
        begin
            $display("ERROR: a = %h, b = %h, c = %h, d = %h | sel = %h | out = %h, expected = %h", a, b, c, d, sel, out, expected);
            error_count = error_count + 1;
        end
    endtask

    task testcase;
        begin
            for (i = 0; i < 4; i = i + 1) begin
                sel = i;
                #10;

                expected = (sel == 2'b00) ? a :
                        (sel == 2'b01) ? b :
                        (sel == 2'b10) ? c :
                        d;

                if (out !== expected)
                    error_task();
            end
        end
    endtask

    initial begin
        $dumpfile("waves/mux4to1_32bit.vcd");
        $dumpvars(0, tb_mux4to1_32bit);

        $display("Running 32-bit 4:1 MUX...");

        // do not test all cases, that's far too many
        // test case 1
        a = 32'h00000000;
        b = 32'hFFFFFFFF;
        c = 32'hAAAAAAAA;
        d = 32'h55555555;
        testcase();

        // test case 2
        a = 32'h12345678;
        b = 32'h87654321;
        c = 32'hDEADBEEF;
        d = 32'hCAFEBABE;
        testcase();

        // test case 3
        a = 32'h00000001;
        b = 32'h80000000;
        c = 32'h00008000;
        d = 32'h00010000;
        testcase();

        // test case 4
        a = 32'h00000005;
        b = 32'h0000000A;
        c = 32'h0000000F;
        d = 32'h00000010;
        testcase();

        // test case 5
        a = 32'h000000FF;
        b = 32'h0000FF00;
        c = 32'h00FF0000;
        d = 32'hFF000000;
        testcase();

        tb_final_display("mux4to1_32bit");

        $finish;
    end
endmodule
