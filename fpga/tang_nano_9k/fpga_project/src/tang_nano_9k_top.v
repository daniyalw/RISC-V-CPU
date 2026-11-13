module tang_nano_9k_top (input clk, input reset_signal, input button, output [5:0] led_o);
    wire [31:0] mem_addr, mem_rdata, mem_wdata;
    wire mem_we, mem_re;

    wire enable = 1'b1;
    wire reset = ~reset_signal; // Tang Nano 9k reset signal is active-low

    cpu_core cpu (.clk(clk), .reset(reset), .enable(enable), .mem_rdata(mem_rdata), .mem_addr(mem_addr), .mem_wdata(mem_wdata), .mem_we(mem_we), .mem_re(mem_re));

    soc_interconnect soci (.clk(clk), .reset(reset), .mem_rdata(mem_rdata), .mem_addr(mem_addr), .mem_wdata(mem_wdata), .mem_we(mem_we), .mem_re(mem_re), .led_o(led_o), .button(button));

endmodule
