task tb_final_display;
    input [145:0] name;
    begin
        $display("%s: %s, %0d tasks completed, %0d errors",
                 (error_count == 0) ? "PASSED" : "FAILED",
                 name,
                 num_tasks,
                 error_count);
    end
endtask
