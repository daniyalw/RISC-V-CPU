module instruction_memory (input [31:0] address, output reg [31:0] instruction);
    wire [31:0] memory[31:0]; // 32 possible instructions, each 32-bits wide

    assign memory[0] = {12'd5, 5'd0, 3'b000, 5'd1, 7'b0010011}; // addi x1, x0, 5
    assign memory[1] = {12'd0, 5'd1, 3'b000, 5'd2, 7'b0010011}; // addi x2, x1, 0
    assign memory[2] = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011}; // add  x3, x1, x2
    assign memory[3] = {12'd0, 5'd3, 3'b000, 5'd4, 7'b0010011}; // addi x4, x3, 0

    always @(*) begin
        instruction = memory[address[31:2]];
    end
endmodule
