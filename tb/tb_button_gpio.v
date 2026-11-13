module tb_button_gpio;
    reg clk = 0, button = 0;
    wire button_out;

    integer num_tasks = 0, error_count = 0, i;
    always #5 clk = ~clk;

    `include "tb/tb_final_display.vh"

    button_gpio btn (.clk(clk), .button(button), .button_out(button_out));

    task btn_check;
        begin
            num_tasks = num_tasks + 1;

            repeat (270_005) @(posedge clk);
            #1;

            if (button_out !== ~button) begin
                $display("Error: test %0d failed.", num_tasks);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/button_gpio.vcd");
        $dumpvars(0, tb_button_gpio);

        $display("Running button GPIO tests...");

        // test 1
        button = 0;

        btn_check();

        // test 2
        button = 1;

        btn_check();

        // test 3
        num_tasks = num_tasks + 1;
        button = 0;
        repeat (3) @(negedge clk);

        button = 1;
        repeat (3) @(negedge clk);
        #1;

        if (button_out !== 1'b0) begin
            $display("Error: button changed during bounce!");
            error_count = error_count + 1;
        end

        tb_final_display("button_gpio");
        $finish;
    end
endmodule
