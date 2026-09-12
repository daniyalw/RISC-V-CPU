module cpu_core (input clk, reset, enable);
    wire [31:0] next_pc, pc;
    wire [31:0] instruction;
    wire [31:0] alu_result;
    wire [31:0] branch_target;
    wire branch_taken;
    wire invalid_instruction;
    wire pc_enable = enable && ~scd.invalid_instruction;

    single_cycle_datapath scd (.instruction(instruction), .clk(clk), .reset(reset), .pc(pc), .alu_result(alu_result), .invalid_instruction(invalid_instruction), .branch_taken(branch_taken), .branch_target(branch_target));
    program_counter pc_counter (.clk(clk), .reset(reset), .enable(pc_enable), .next_pc(next_pc), .pc(pc));
    instruction_memory inst_mem (.address(pc), .instruction(instruction));
    pc_plus_4 pc4 (.pc(pc), .branch_taken(branch_taken), .branch_target(branch_target), .next_pc(next_pc));
endmodule
