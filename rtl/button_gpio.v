module button_gpio (input clk, input button, output button_out);
    reg sync1, sync2;
    localparam integer DEBOUNCE_CYCLES = 270_000;
    reg [18:0] debounce_counter = 0;
    reg stable_button = 1'b1;  // released

    always @(posedge clk) begin
        sync1 <= button;
        sync2 <= sync1;
    end

    always @(posedge clk) begin
        if (sync2 == stable_button) begin
            debounce_counter <= 0;
        end
        else if (debounce_counter == (DEBOUNCE_CYCLES - 1)) begin
            stable_button <= sync2;
            debounce_counter <= 0;
        end
        else begin
            debounce_counter <= debounce_counter + 1'b1;
        end
    end

    assign button_out = ~stable_button;
endmodule
