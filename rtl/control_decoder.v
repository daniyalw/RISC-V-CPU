module control_decoder (input [6:0] opcode, input [2:0] funct3, input [6:0] funct7, output reg [2:0] alu_op, output reg branch, output reg [1:0] branch_type, output reg alu_src, reg_write, invalid_instruction, mem_read, mem_write, mem_to_reg, jal_enable, jalr_enable, lui_enable); // must always use `output reg` for outputs that are modified inside an `always` block because the values are assigned procedurally
    always @ (*) begin
        // safe defaults
        alu_op = 3'b111; // 3'b000 is the adder opcode, so using the unused 3'b111 as invalid opcode makes it easy for the ALU to notice that
        alu_src = 1'b0;
        reg_write = 1'b0;
        invalid_instruction = 1'b1;

        branch = 1'b0;
        branch_type = 2'b00;

        mem_read = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;

        jal_enable = 1'b0; // always zero unless jal instruction
        jalr_enable = 1'b0;

        lui_enable = 1'b0;

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
        end else if (opcode == 7'b1100111) begin
            // I-type JALR instruction
            jalr_enable = 1'b1;
            jal_enable = 1'b1;
            reg_write = 1'b1;
            mem_to_reg = 1'b0;
            invalid_instruction = 1'b0;
        end else if (opcode == 7'b0000011) begin
            if (funct3 == 3'b010) begin
                // lw
                mem_read = 1'b1; mem_write = 1'b0;
                alu_op = 3'b000; // add because the ALU will compute the data memory address to load word from (addr = rs1_data + immediate)
                alu_src = 1'b1; // alu_src=1 so that the datapath selects the immediate instead of rs2_data for the second argument for ALU op
                mem_to_reg = 1'b1; // so that the data memory output is written to rd_data
                reg_write = 1'b1;
                invalid_instruction = 1'b0;
            end else begin
                // all invalid funct3 values end up here, so default values (invalid) prevail
            end
        end else if (opcode == 7'b1100011) begin
            // B-type
            if (funct3 == 3'b000) begin
                // BEQ - branch if equal
                branch = 1'b1;
                branch_type = 2'b00;
                invalid_instruction = 1'b0;
            end else if (funct3 == 3'b001) begin
                // BNE - branch if not equal
                branch = 1'b1;
                branch_type = 2'b01;
                invalid_instruction = 1'b0;
            end else begin
            // all invalid funct3 end up here, default values (invalid) prevail
            end
        end else if (opcode == 7'b0100011) begin
            // S-type
            if (funct3 == 3'b010) begin
                // sw
                mem_write = 1'b1; mem_read = 1'b0;
                alu_op = 3'b000; // add, so ALU can add rs1_data + immediate
                alu_src = 1'b1; // so datapath picks immediate instead of rs2_data for second argument for ALU op
                mem_to_reg = 1'b0; reg_write = 1'b0; // no data memory output
                invalid_instruction = 1'b0;
            end else begin
                // all invalid funct3 end up here, default values (invalid) prevail
            end
        end else if (opcode == 7'b1101111) begin
            // J-type
            reg_write = 1'b1;
            mem_to_reg = 1'b0;
            jal_enable = 1'b1;
            invalid_instruction = 1'b0;
        end else if (opcode == 7'b0110111) begin
            // U-type
            reg_write = 1'b1;
            lui_enable = 1'b1;

            mem_to_reg = 1'b0;
            jal_enable = 1'b0;

            invalid_instruction = 1'b0;
        end
    end
endmodule
