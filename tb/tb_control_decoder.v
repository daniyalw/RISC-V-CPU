module tb_control_decoder;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;
    wire [2:0] alu_op;
    wire [1:0] branch_type;
    wire alu_src, reg_write, invalid_instruction, branch;

    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    control_decoder uut (.opcode(opcode), .funct3(funct3), .funct7(funct7), .alu_op(alu_op), .alu_src(alu_src), .branch(branch), .branch_type(branch_type), .reg_write(reg_write), .invalid_instruction(invalid_instruction));

    task check;
        input [2:0] expected_op;
        input expected_src, expected_regwrite, expected_invalid;
        input expected_branch;
        input [1:0] expected_branch_type;

        begin
            num_tasks = num_tasks + 1;

            #1;

            if ((alu_op !== expected_op) || (alu_src !== expected_src) || (reg_write !== expected_regwrite) || (invalid_instruction !== expected_invalid) || (branch !== expected_branch) || (branch_type !== expected_branch_type)) begin
                $display("Error: test %0d | opcode = %b, funct3 = %b, funct7 = %b | alu_op = %b (expected = %b), alu_src = %b (expected = %b), reg_write = %b (expected = %b), invalid_instruction = %b (expected = %b), branch = %b (expected = %b), branch_type = %b (expected = %b)\n\n", num_tasks, opcode, funct3, funct7, alu_op, expected_op, alu_src, expected_src, reg_write, expected_regwrite, invalid_instruction, expected_invalid, branch, expected_branch, branch_type, expected_branch_type);
                error_count = error_count + 1;
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
        check(3'b000, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 2 - SUB
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0100000;
        check(3'b001, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 3 - AND
        opcode = 7'b0110011; funct3 = 3'b111; funct7 = 7'b0000000;
        check(3'b010, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 4 - OR
        opcode = 7'b0110011; funct3 = 3'b110; funct7 = 7'b0000000;
        check(3'b011, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 5 - XOR
        opcode = 7'b0110011; funct3 = 3'b100; funct7 = 7'b0000000;
        check(3'b100, 1'b0, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 6 - ADDI
        opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000;
        check(3'b000, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 7 - ANDI
        opcode = 7'b0010011; funct3 = 3'b111; funct7 = 7'b0000000;
        check(3'b010, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 8 - ORI
        opcode = 7'b0010011; funct3 = 3'b110; funct7 = 7'b0000000;
        check(3'b011, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 9 - XORI
        opcode = 7'b0010011; funct3 = 3'b100; funct7 = 7'b0000000;
        check(3'b100, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00);

        // test 10 - BEQ
        opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000;
        check(3'b111, 1'b0, 1'b0, 1'b0, 1'b1, 2'b00);

        // test 11 - BNE
        opcode = 7'b1100011; funct3 = 3'b001; funct7 = 7'b0000000;
        check(3'b111, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01);

        // invalid cases
        // test 1 - unsuported I-type
        opcode = 7'b0010011; funct3 = 3'b001; funct7 = 7'b0000000;
        check(3'b111, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00);

        // test 2 - unsupported opcode
        opcode = 7'b0000011; funct3 = 3'b111; funct7 = 7'b0000000;
        check(3'b111, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00);

        // test 3 - bad R-type funct7 for ADD/SUB (ADD)
        opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b1111111;
        check(3'b111, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00);

        // test 4 - bad R-type funct7 for AND/OR/XOR (AND)
        opcode = 7'b011011; funct3 = 3'b111; funct7 = 7'b1111111;
        check(3'b111, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00);

        // test 5 - branch opcode but not valid funct3
        opcode = 7'b1100011; funct3 = 3'b100; funct7 = 7'b0000000;
        check(3'b111, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00);

        tb_final_display("control_decoder");

        $finish;
    end
endmodule
