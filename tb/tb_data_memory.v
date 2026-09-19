module tb_data_memory;
    reg clk = 0, mem_write = 0, mem_read = 0, reset = 0;
    reg [31:0] address, write_data;
    wire [31:0] out_data;

    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    always #5 clk = ~clk;

    data_memory dm (.clk(clk), .reset(reset), .mem_write(mem_write), .mem_read(mem_read), .address(address), .write_data(write_data), .out_data(out_data));

    task check_lw;
        input [31:0] expected_out;

        begin
            num_tasks = num_tasks + 1;

            #1;

            if (out_data !== expected_out) begin
                $display("Error: test %0d | clk=%0d mem_write=%b mem_read=%b address=%h write_data=%h | out_data=%h (expected=%h)", num_tasks, clk, mem_write, mem_read, address, write_data, out_data, expected_out);
                error_count = error_count + 1;
            end
        end
    endtask

    task check_sw;
        input [31:0] expected_in;

        begin
            num_tasks = num_tasks + 1;

            @(posedge clk); #1;

            if (dm.datamem[address[31:2]] !== expected_in) begin
                $display("Error: test %0d | clk=%0d mem_write=%b mem_read=%b address=%h write_data=%h | in_data=%h (expected=%h)", num_tasks, clk, mem_write, mem_read, address, write_data, dm.datamem[address[31:2]], expected_in);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/data_memory.vcd");
        $dumpvars(0, tb_data_memory);

        $display("Running data memory tests...");

        reset = 1;
        #1;
        reset = 0;

        // test 1 - read address 0
        mem_read = 1;
        address = 0;
        check_lw(32'd0);
        mem_read = 0;

        // test 2 - write to address 0 (we check this using test 3, which will be a read of address 0)
        address = 0;
        write_data = 32'hDEADBEEF;
        mem_write = 1;
        check_sw(32'hDEADBEEF);
        mem_write = 0;

        // test 3 - read address 0 after having written to it
        address = 0;
        mem_read = 1;
        check_lw(32'hDEADBEEF);
        mem_read = 0;

        // test 4 - write the number 42 to address 4
        address = 32'd4;
        write_data = 32'd42;
        mem_write = 1;
        check_sw(32'd42);
        mem_write = 0;

        // test 5 - read address 4
        address = 32'd4;
        mem_read = 1;
        check_lw(32'd42);
        mem_read = 0;

        // test 6 - read address 0, should be DEADBEEF
        address = 0;
        mem_read = 1;
        check_lw(32'hDEADBEEF);
        mem_read = 0;

        // test 7 - write AAAAAAAA to address 4
        address = 32'd4;
        write_data = 32'hAAAAAAAA;
        mem_write = 1;
        check_sw(32'hAAAAAAAA);
        mem_write = 0;

        // test 8 - read address 4, should be AAAAAAAA
        address = 32'd4;
        mem_read = 1;
        check_lw(32'hAAAAAAAA);
        mem_read = 0;

        // test 9 - put 45 in write_data but mem_write=0 so nothing should be written
        address = 32'd4;
        write_data = 32'd45;
        mem_write = 0;
        check_sw(32'hAAAAAAAA);
        mem_write = 0;

        // test 10 - read address 4, should NOT be 45, should be AAAAAAAA
        address = 32'd4;
        mem_read = 1;
        check_lw(32'hAAAAAAAA);
        mem_read = 0;

        // test 11 - get output when mem_read=0
        address = 32'd0;
        mem_read = 0;
        check_lw(32'd0);
        mem_read = 0;

        tb_final_display("data_memory");

        $finish;
    end
endmodule
