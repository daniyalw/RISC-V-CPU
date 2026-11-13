module led_gpio (input clk, reset, write_enable, input [31:0] write_data, output [5:0] led_o);
    reg [5:0] led_reg; // six LEDs

    always @(posedge clk or posedge reset)
        if (reset)
            led_reg = 6'b0;
        else if (write_enable)
            led_reg = write_data[5:0];

    // Tang Nano 9K LEDs are active-low
    assign led_o = ~led_reg;
endmodule
