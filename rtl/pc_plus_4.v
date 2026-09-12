module pc_plus_4 (input [31:0] pc, branch_target, input branch_taken, output [31:0] next_pc);
    wire [31:0] no_branch_pc = pc + 32'd4;
    assign next_pc = branch_taken ? branch_target : no_branch_pc;
endmodule
