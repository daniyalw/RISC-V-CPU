// no testbench available for this module because it's just a wrapper
module program_counter (input clk, reset, enable, input [31:0] next_pc, output [31:0] pc);
    register_32bit r (.clk(clk), .reset(reset), .enable(enable), .d(next_pc), .q(pc));
endmodule
