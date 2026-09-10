module control_decoder (input [6:0] opcode, input [2:0] funct3, input [6:0] funct7, output reg [2:0] alu_op, output reg alu_src, reg_write, invalid_instruction); // must always use `output reg` for outputs that are modified inside an `always` block because the values are assigned procedurally
    always @ (*) begin
        // safe defaults
        alu_op = 3'b111; // 3'b000 is the adder opcode, so using the unused 3'b111 as invalid opcode makes it easy for the ALU to notice that
        alu_src = 1'b0;
        reg_write = 1'b0;
        invalid_instruction = 1'b1;

        if (opcode == 7'b0110011) begin
            // R-type
            alu_src = 1'b0;
            reg_write = 1'b1;
            invalid_instruction = 1'b0;

            if (funct3 == 3'b000) begin
                if (funct7 == 7'b0000000) begin
                    // ADD
                    alu_op = 3'b000;
                end else if (funct7 == 7'b0100000) begin
                    // SUB
                    alu_op = 3'b001;
                end else begin
                    alu_src = 1'b0;
                    reg_write = 1'b0;
                    invalid_instruction = 1'b1;
                end
            end else if ((funct3 == 3'b111) && (funct7 == 7'b0000000)) begin
                // AND
                alu_op = 3'b010;
            end else if ((funct3 == 3'b110) && (funct7 == 7'b0000000)) begin
                // OR
                alu_op = 3'b011;
            end else if ((funct3 == 3'b100) && (funct7 == 7'b0000000)) begin
                // XOR
                alu_op = 3'b100;
            end else begin
                // invalid
                invalid_instruction = 1'b1;
                reg_write = 1'b0;
                alu_src = 1'b0;
            end
        end else if (opcode == 7'b0010011) begin
            // I-type ALU immediate
            // don't check funct7 here because the bits for funct7 are part of the immediate for the I-type
            if (funct3 == 3'b000) begin
                // addi
                alu_op = 3'b000;
                alu_src = 1'b1;
                reg_write = 1'b1;
                invalid_instruction = 1'b0;
            end else if (funct3 == 3'b100) begin
                // xori
                alu_op = 3'b100;
                alu_src = 1'b1;
                reg_write = 1'b1;
                invalid_instruction = 1'b0;
            end else if (funct3 == 3'b110) begin
                // ori
                alu_op = 3'b011;
                alu_src = 1'b1;
                reg_write = 1'b1;
                invalid_instruction = 1'b0;
            end else if (funct3 == 3'b111) begin
                // andi
                alu_op = 3'b010;
                alu_src = 1'b1;
                reg_write = 1'b1;
                invalid_instruction = 1'b0;
            end else begin
                // all invalid funct3 values end up here, so default values (invalid) prevail
            end
        end
    end
endmodule
