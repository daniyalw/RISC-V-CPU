module instruction_memory (input [31:0] address, output reg [31:0] instruction);
    always @(*) begin
        case (address[31:2])
            30'd0: instruction = {12'd12, 5'd0, 3'b000, 5'd1, 7'b0010011}; // addi x1, x0, 12
            30'd1: instruction = {12'd10, 5'd1, 3'b111, 5'd2, 7'b0010011}; // andi x2, x1, 10
            30'd2: instruction = {12'd3, 5'd2, 3'b110, 5'd3, 7'b0010011}; // ori  x3, x2, 3
            30'd3: instruction = {12'd15, 5'd3, 3'b100, 5'd4, 7'b0010011}; // xori x4, x3, 15
            30'd4: instruction = {7'b0000000, 5'd1, 5'd4, 3'b000, 5'd5, 7'b0110011}; // add  x5, x4, x1
            30'd5: instruction = {7'b0100000, 5'd2, 5'd5, 3'b000, 5'd6, 7'b0110011}; // sub  x6, x5, x2
            default: instruction = 32'h00000000; // end of instructions
        endcase
    end
endmodule
