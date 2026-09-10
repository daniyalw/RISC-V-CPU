module instruction_memory (input [31:0] address, output reg [31:0] instruction);
    wire [31:0] memory[31:0]; // 32 possible instructions, each 32-bits wide

    always @(*) begin
        case (address[31:2])
            30'd0: instruction = {12'd5, 5'd0, 3'b000, 5'd1, 7'b0010011};
            30'd1: instruction = {12'd0, 5'd1, 3'b000, 5'd2, 7'b0010011};
            30'd2: instruction = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011};
            30'd3: instruction = {12'd0, 5'd3, 3'b000, 5'd4, 7'b0010011};
            default: instruction = 32'h00000000; // invalid/unsupported for halt, or NOP if desired
        endcase
    end
endmodule
