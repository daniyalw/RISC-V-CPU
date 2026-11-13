module soc_interconnect(input clk, input reset, input [31:0] mem_addr, input [31:0] mem_wdata, input mem_we, input mem_re, output reg [31:0] mem_rdata, output [5:0] led_o);
    // 0x0 - 0x7F: RAM
    // 0x80 - 0x1FFF: reserved RAM
    // 0x2000 - 0x2FFF: GPIO registers (0x2000 is for LED)
    // 0x3000 - 0x3FFF: reserved for future UART
    // 0x4000 - 0x4FFF: reserved for future timer

    reg datamem_en = 0;
    reg lgpio_en = 0;

    wire [31:0] ram_rdata;

    always @*
        datamem_en = (mem_addr >= 32'h0) && (mem_addr <= 32'h7F);

    always @*
        lgpio_en = (mem_addr == 32'h2000);

    data_memory dm (.clk(clk), .reset(reset), .mem_write(mem_we && datamem_en), .mem_read(mem_re && datamem_en), .address(mem_addr), .write_data(mem_wdata), .out_data(ram_rdata));
    led_gpio lgpio (.clk(clk), .reset(reset), .write_enable(mem_we && lgpio_en), .write_data(mem_wdata), .led_o(led_o));

    always @*
        if (datamem_en)
            mem_rdata = ram_rdata;
        else
            mem_rdata = 32'h0;

endmodule
