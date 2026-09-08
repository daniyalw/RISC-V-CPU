task tb_final_display;
    input [200:0] name;
    begin
        $display("%s: %s, %0d tests completed, %0d errors",
                 (error_count == 0) ? "PASSED" : "FAILED",
                 name,
                 num_tasks,
                 error_count);
    end
endtask
