module tb_soc_interconnect;
    reg clk = 0, reset = 0, mem_we = 0, mem_re = 0;
    reg [31:0] mem_addr = 32'h0, mem_wdata = 32'h0, data_at_addr = 32'h0;
    wire [31:0] mem_rdata;
    wire [5:0] led_o;

    always #5 clk = ~clk;

    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    soc_interconnect soci (.clk(clk), .reset(reset), .mem_we(mem_we), .mem_re(mem_re), .mem_addr(mem_addr), .mem_wdata(mem_wdata), .mem_rdata(mem_rdata), .led_o(led_o));

    task datamem_test;
        input [31:0] prev_write;
        input prev_write_enable;

        begin
            num_tasks = num_tasks + 1;

            if (mem_addr <= 32'h7F)
                data_at_addr = soci.dm.datamem[mem_addr[31:2]];

            @(posedge clk); #1;

            if (mem_addr > 32'h7F) begin
                if (soci.datamem_en !== 1'b0) begin
                    $display("Test %0d: RAM enable on even though memory outside of RAM range.", num_tasks);
                    error_count = error_count + 1;
                end
            end

            // test datamem_en
            if ((mem_addr >= 32'h0) && (mem_addr <= 32'h7F)) begin
                if (soci.datamem_en == 1'b0) begin
                    $display("Test %0d: RAM enable off despite memory address in valid range.", num_tasks);
                    error_count = error_count + 1;
                end
            end else if (soci.datamem_en == 1'b0) begin
                if (mem_rdata !== 32'h0) begin
                    $display("Test %0d: Memory read data not 0 despite RAM enable off", num_tasks);
                    error_count = error_count + 1;
                end
            end

            // test if written
            if (mem_we && (mem_addr <= 32'h7F)) begin
                if (mem_wdata !== soci.dm.datamem[mem_addr[31:2]]) begin
                    $display("Test %0d: To-write data not written to RAM.", num_tasks);
                    error_count = error_count + 1;
                end
            end

            // test if read
            if (mem_re && (mem_addr <= 32'h7F)) begin
                if (mem_rdata !== soci.dm.datamem[mem_addr[31:2]]) begin
                    $display("Test %0d: Data not read from RAM.", num_tasks);
                    error_count = error_count + 1;
                end else if (prev_write_enable && (mem_rdata !== prev_write)) begin
                    $display("Test %0d: Data not read from RAM.", num_tasks);
                    error_count = error_count + 1;
                end
            end

            // test if not written
            if ((mem_we == 0) && (mem_addr <= 32'h7F)) begin
                if (data_at_addr !== soci.dm.datamem[mem_addr[31:2]]) begin
                    $display("Test %0d: Data written to RAM despite write enable being off.", num_tasks);
                    error_count = error_count + 1;
                end
            end
        end
    endtask

    task led_gpio_test;
        begin
            num_tasks = num_tasks + 1;

            data_at_addr = {26'b0, led_o}; // 32 bits

            @(posedge clk); #1;

            // test lgpio_en
            if (mem_addr == 32'h2000) begin
                if (soci.lgpio_en == 1'b0) begin
                    $display("Test %0d: LGPIO enable off despite memory address in valid range.", num_tasks);
                    error_count = error_count + 1;
                end
            end else begin
                if (soci.lgpio_en !== 1'b0) begin
                    $display("Test %0d: LGPIO enable on despite memory address invalidity.", num_tasks);
                    error_count = error_count + 1;
                end
            end

            // test write
            if (mem_we && (mem_addr == 32'h2000)) begin
                if (led_o !== ~mem_wdata[5:0]) begin
                    $display("Test %0d: LED register not valid write output.", num_tasks);
                    error_count = error_count + 1;
                end
            end else begin
                if (led_o !== data_at_addr[5:0]) begin
                    $display("Test %0d: LED register not valid write output.", num_tasks);
                    error_count = error_count + 1;
                end
            end

            // test no write
            if ((mem_we == 0) && (mem_addr == 32'h2000)) begin
                if (data_at_addr[5:0] !== led_o) begin
                    $display("Test %0d: LGPIO written to despite enable being off.", num_tasks);
                    error_count = error_count + 1;
                end
            end
        end
    endtask

    initial begin
        $dumpfile("waves/soc_interconnect.vcd");
        $dumpvars(0, tb_soc_interconnect);

        $display("Running SoC Interconnect tests...");

        reset = 1;
        #1;
        reset = 0;

        // RAM tests
        // test 1
        mem_addr = 32'h4;
        mem_wdata = 32'b1010;
        mem_we = 1'b1;

        datamem_test(0, 0);

        // test 2
        mem_addr = 32'h4;
        mem_we = 1'b0;
        mem_re = 1'b1;

        datamem_test(32'b1010, 1);

        // test 3
        mem_addr = 32'h8;
        mem_we = 1'b0;
        mem_re = 1'b1;

        datamem_test(0, 1);

        mem_re = 1'b0;

        // test 4
        mem_addr = 32'h8;
        mem_we = 1'b1;
        mem_wdata = 32'b1010;
        mem_re = 1'b0;

        datamem_test(0, 0);

        mem_we = 0;
        mem_re = 0;

        // test 5
        mem_re = 1'b1;

        datamem_test(32'b1010, 1);

        // test 6
        mem_addr = 32'h80;
        mem_we = 1'b0;
        mem_re = 1'b1;

        datamem_test(0, 1);

        // final test
        mem_addr = 32'h2000; // data memory enable will be off

        datamem_test(0, 0);

        // LED GPIO tests
        // test 1
        mem_addr = 32'h2000;
        mem_we = 1'b0;
        mem_wdata = 32'b1010;

        led_gpio_test();

        // test 2
        mem_we = 1'b1;

        led_gpio_test();

        // test 3
        mem_we = 1'b0;
        mem_wdata = 32'b0101;

        led_gpio_test();

        // OTHER TESTS
        // test 1
        mem_addr = 32'h2004;
        mem_we = 1'b1;
        mem_wdata = 32'b1111;

        led_gpio_test();

        tb_final_display("soc_interconnect");

        $finish;
    end
endmodule
