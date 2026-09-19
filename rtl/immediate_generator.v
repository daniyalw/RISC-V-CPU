module immediate_generator (input [31:0] instruction, output reg [31:0] immediate);
    reg [6:0] opcode;

    always @(*) begin
        opcode = instruction[6:0];

        // the regular I-type and LW both have the same immediate format, so we just use that even though they have different opcodes
        if ((opcode == 7'b0010011) || (opcode == 7'b0000011)) // I-type (including lw)
            immediate = {{20{instruction[31]}}, instruction[31:20]};
        else if (opcode == 7'b1100011) // B-type
            immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        else if (opcode == 7'b0100011) // S-type
            immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        else
            immediate = 32'd0; // invalid
    end
endmodule
