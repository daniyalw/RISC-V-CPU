module register_32bit (input clk, reset, enable, input [31:0] d, output reg [31:0] q);
    // always at the rising edge of the clock OR the rising edge of the reset signal
    always @ (posedge clk or posedge reset) begin // async reset
        if (reset == 1) begin
            q <= {32{1'b0}};
        end else if (enable == 1) begin
            q <= d;
        end
    end
endmodule
