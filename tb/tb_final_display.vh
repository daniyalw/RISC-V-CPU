task tb_final_display;
    input [200:0] name;
    begin
        $display("%s: %s, %0d test(s) completed, %0d error(s)",
                 (error_count == 0) ? "PASSED" : "FAILED",
                 name,
                 num_tasks,
                 error_count);
    end
endtask
