module tb_control_decoder;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [2:0] alu_op;
    wire [1:0] branch_type;
    wire alu_src, reg_write, invalid_instruction, branch, mem_read, mem_write, mem_to_reg, jal_enable, jalr_enable, lui_enable, auipc_enable;

    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    control_decoder uut (.opcode(opcode), .funct3(funct3), .funct7(funct7), .alu_op(alu_op), .alu_src(alu_src), .branch(branch), .branch_type(branch_type), .reg_write(reg_write), .invalid_instruction(invalid_instruction), .mem_read(mem_read), .mem_write(mem_write), .mem_to_reg(mem_to_reg), .jal_enable(jal_enable), .jalr_enable(jalr_enable), .lui_enable(lui_enable), .auipc_enable(auipc_enable));

    task display_info;
        begin
            $display("Error: test %0d | opcode = %b, funct3 = %b, funct7 = %b", num_tasks, opcode, funct3, funct7);
            error_count = error_count + 1;
        end
    endtask

    // for ALU tests
    task check_gen_task;
        input [2:0] expected_op;
        input expected_src, expected_regwrite;

        begin
            num_tasks = num_tasks + 1;

            #1;

            if ((alu_op !== expected_op) || (alu_src !== expected_src) || (reg_write !== expected_regwrite) || (invalid_instruction !== 1'b0)) begin
                display_info();
                $display("alu_op = %b (expected = %b), alu_src = %b (expected = %b), reg_write = %b (expected = %b), invalid_instruction = %b (expected = 0)\n\n", alu_op, expected_op, alu_src, expected_src, reg_write, expected_regwrite, invalid_instruction);
            end
        end
    endtask

    // for U-type (LUI, auipc) tests
    task check_utype_task;
        input expected_regwrite, expected_lui_enable, expected_auipc_enable;

        begin
            num_tasks = num_tasks + 1;

            #1;

            if ((reg_write !== expected_regwrite) || (lui_enable !== expected_lui_enable) || (auipc_enable !== expected_auipc_enable) || (invalid_instruction !== 1'b0)) begin
                display_info();
                $display("reg_write=%b (expected=%b)   lui_enable=%b (expected=%b)   auipc_enable=%b (expected=%b)   invalid_instruction=%b (expected=%b)",
                            reg_write, expected_regwrite,
                            lui_enable, expected_lui_enable,
                            auipc_enable, expected_auipc_enable,
                            invalid_instruction, 1'b0);
            end
        end
    endtask

    // for branching tests
    task check_branch_task;
        input expected_branch;
        input [1:0] expected_branch_type;

        begin
            num_tasks = num_tasks + 1;

            #1;

            if ((branch !== expected_branch) || (branch_type !== expected_branch_type) || (invalid_instruction !== 1'b0)) begin
                display_info();
                $display("branch = %b (expected = %b), branch_type = %b (expected = %b), invalid_instruction = %b (expected = 0)\n\n", branch, expected_branch, branch_type, expected_branch_type, invalid_instruction);
            end
        end
    endtask

    task check_mem_task;
        input expected_mem_read, expected_mem_write, expected_mem_to_reg;

        begin
            num_tasks = num_tasks + 1;

            #1;

            if ((mem_read !== expected_mem_read) || (mem_write !== expected_mem_write) || (mem_to_reg !== expected_mem_to_reg) || (invalid_instruction !== 1'b0)) begin
                display_info();
                $display("mem_read = %b (expected = %b), mem_write = %b (expected = %b), mem_to_reg = %b (expected = %b)\n\n", mem_read, expected_mem_read, mem_write, expected_mem_write, mem_to_reg, expected_mem_to_reg);
            end
        end
    endtask

    task check_invalid;
        begin
            num_tasks = num_tasks + 1;

            #1;

            if ((alu_op !== 3'b111) || (branch !== 1'b0) || (branch_type !== 2'b00) || (alu_src !== 1'b0) || (reg_write !== 1'b0) || (mem_read !== 1'b0) || (mem_write !== 1'b0) || (mem_to_reg !== 1'b0) || (invalid_instruction !== 1'b1)) begin
                display_info();
                $display("alu_op = %b (expected = 111), branch = %b (expected = 0), branch_type = %b (expected = 00), alu_src = %b (expected = 0), reg_write = %b (expected = 0), mem_read = %b (expected = 0), mem_write = %b (expected = 0), mem_to_reg = %b (expected = 0), invalid_instruction = %b (expected = 1)\n\n", alu_op, branch, branch_type, alu_src, reg_write, mem_read, mem_write, mem_to_reg, invalid_instruction);
            end
        end
    endtask

    task check_jal;
        input expected_regwrite, expected_mem_to_reg, expected_jal_enable, expected_jalr_enable;

        begin
            num_tasks = num_tasks + 1;

            #1;

            if ((reg_write !== expected_regwrite) || (mem_to_reg !== expected_mem_to_reg) || (jal_enable !== expected_jal_enable) || (jalr_enable !== expected_jalr_enable) || (invalid_instruction !== 1'b0)) begin
                display_info();
                $display("reg_write = %b (expected = %b), mem_to_reg = %b (expected=%b), jal_enable = %b (expected = %b), jalr_enable = %b (expected = %b) invalid_instruction = %b (expected = %b)", reg_write, expected_regwrite, mem_to_reg, expected_mem_to_reg, jal_enable, expected_jal_enable, jalr_enable, expected_jalr_enable, invalid_instruction, 1'b0);
            end
        end
    endtask

    initial begin
        $dumpfile("waves/control_decoder.vcd");
        $dumpvars(0, tb_control_decoder);

        $display("Running control decoder tests...");

        // valid cases
        // test 1 - ADD
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000;
        check_gen_task(3'b000, 1'b0, 1'b1);

        // test 2 - SUB
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0100000;
        check_gen_task(3'b001, 1'b0, 1'b1);

        // test 3 - AND
        opcode = 7'b0110011; funct3 = 3'b111; funct7 = 7'b0000000;
        check_gen_task(3'b010, 1'b0, 1'b1);

        // test 4 - OR
        opcode = 7'b0110011; funct3 = 3'b110; funct7 = 7'b0000000;
        check_gen_task(3'b011, 1'b0, 1'b1);

        // test 5 - XOR
        opcode = 7'b0110011; funct3 = 3'b100; funct7 = 7'b0000000;
        check_gen_task(3'b100, 1'b0, 1'b1);

        // test 6 - ADDI
        opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000;
        check_gen_task(3'b000, 1'b1, 1'b1);

        // test 7 - ANDI
        opcode = 7'b0010011; funct3 = 3'b111; funct7 = 7'b0000000;
        check_gen_task(3'b010, 1'b1, 1'b1);

        // test 8 - ORI
        opcode = 7'b0010011; funct3 = 3'b110; funct7 = 7'b0000000;
        check_gen_task(3'b011, 1'b1, 1'b1);

        // test 9 - XORI
        opcode = 7'b0010011; funct3 = 3'b100; funct7 = 7'b0000000;
        check_gen_task(3'b100, 1'b1, 1'b1);

        // test 10 - BEQ
        opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000;
        check_branch_task(1'b1, 2'b00);

        // test 11 - BNE
        opcode = 7'b1100011; funct3 = 3'b001; funct7 = 7'b0000000;
        check_branch_task(1'b1, 2'b01);

        // test 12 - SW
        opcode = 7'b0100011; funct3 = 3'b010; funct7 = 7'b000000;
        check_mem_task(1'b0, 1'b1, 1'b0);

        // test 13 - LW
        opcode = 7'b0000011; funct3 = 3'b010; funct7 = 7'b000000;
        check_mem_task(1'b1, 1'b0, 1'b1);

        // test 14 - JAL
        opcode = 7'b1101111; funct3 = 3'b000; funct7 = 7'b000000; // funct3 and funct7 are not needed for JAL
        check_jal(1'b1, 1'b0, 1'b1, 1'b0);

        // test 15 - JALR
        opcode = 7'b1100111; funct3 = 3'b000; funct7 = 7'b000000;
        check_jal(1'b1, 1'b0, 1'b1, 1'b1);

        // test 16 - LUI
        opcode = 7'b0110111; funct3 = 3'b000; funct7 = 7'b000000;
        check_utype_task(1'b1, 1'b1, 1'b0);

        // test 17 - auipc
        opcode = 7'b0010111; funct3 = 3'b000; funct7 = 7'b000000;
        check_utype_task(1'b1, 1'b0, 1'b1);

        // invalid cases
        // test 1 - unsuported I-type
        opcode = 7'b0010011; funct3 = 3'b001; funct7 = 7'b0000000;
        check_invalid();

        // test 2 - unsupported opcode
        opcode = 7'b1111111; funct3 = 3'b111; funct7 = 7'b0000000;
        check_invalid();

        // test 3 - bad R-type funct7 for ADD/SUB (ADD)
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b1111111;
        check_invalid();

        // test 4 - bad R-type funct7 for AND/OR/XOR (AND)
        opcode = 7'b0110011; funct3 = 3'b111; funct7 = 7'b1111111;
        check_invalid();

        // test 5 - branch opcode but not valid funct3
        opcode = 7'b1100011; funct3 = 3'b100; funct7 = 7'b0000000;
        check_invalid();

        tb_final_display("control_decoder");

        $finish;
    end
endmodule
