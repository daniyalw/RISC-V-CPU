module immediate_generator (input [31:0] instruction, output reg [31:0] immediate);
    reg [6:0] opcode;

    always @(*) begin
        opcode = instruction[6:0];

        // the regular I-type and LW both have the same immediate format, so we just use that even though they have different opcodes
        if ((opcode == 7'b0010011) || (opcode == 7'b0000011) || (opcode == 7'b1100111)) // I-type (including lw and jalr)
            immediate = {{20{instruction[31]}}, instruction[31:20]};
        else if (opcode == 7'b1100011) // B-type
            immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        else if (opcode == 7'b0100011) // S-type
            immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        else if (opcode == 7'b1101111) // J-type
            immediate = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        else if ((opcode == 7'b0110111) || (opcode == 7'b0010111)) // U-type (LUI, AUIPC)
            immediate = {instruction[31:12], 12'b0};
        else
            immediate = 32'd0; // invalid
    end
endmodule
