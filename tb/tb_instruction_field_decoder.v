module tb_instruction_field_decoder;
    reg [31:0] instruction;
    wire [6:0] opcode;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [4:0] rs1, rs2;
    wire [6:0] funct7;

    integer num_tasks = 0, error_count = 0;

    `include "tb/tb_final_display.vh"

    instruction_field_decoder uut (.instruction(instruction), .opcode(opcode), .rd(rd), .funct3(funct3), .rs1(rs1), .rs2(rs2), .funct7(funct7));

    task check_task;
        input [6:0] expected_opcode;
        input [4:0] expected_rd;
        input [2:0] expected_funct3;
        input [4:0] expected_rs1, expected_rs2;
        input [6:0] expected_funct7;

        begin
            num_tasks = num_tasks + 1;

            if ((opcode !== expected_opcode) || (rd !== expected_rd) || (funct3 !== expected_funct3) || (rs1 !== expected_rs1) || (rs2 !== expected_rs2) || (funct7 !== expected_funct7)) begin
                $display("Error: instruction = %b\n\nOpcode = %b (expected = %b)\nrd = %b (expected = %b)\nfunct3 = %b (expected = %b)\nrs1 = %b (expected = %b)\nrs2 = %b (expected = %b)\nfunct7 = %b (expected = %b)", instruction, opcode, expected_opcode, rd, expected_rd, funct3, expected_funct3, rs1, expected_rs1, rs2, expected_rs2, funct7, expected_funct7);
                error_count = error_count + 1;
            end
        end
    endtask

    task check_i_task;
        input [6:0] expected_opcode;
        input [4:0] expected_rd;
        input [2:0] expected_funct3;
        input [4:0] expected_rs1;

        begin
            num_tasks = num_tasks + 1;

            if ((opcode !== expected_opcode) || (rd !== expected_rd) || (funct3 !== expected_funct3) || (rs1 !== expected_rs1)) begin
                $display("Error: instruction = %b\n\nOpcode = %b (expected = %b)\nrd = %b (expected = %b)\nfunct3 = %b (expected = %b)\nrs1 = %b (expected = %b)", instruction, opcode, expected_opcode, rd, expected_rd, funct3, expected_funct3, rs1, expected_rs1);
                error_count = error_count + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("waves/instruction_field_decoder.vcd");
        $dumpvars(0, tb_instruction_field_decoder);

        $display("Running instruction field decoder tests...");

        // test case 1 - ADD
        instruction = {7'b0000000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011};
        #1;
        check_task(7'b0110011, 5'd3, 3'b000, 5'd1, 5'd2, 7'b0000000);

        // test case 2 - SUB
        instruction = {7'b0100000, 5'd2, 5'd1, 3'b000, 5'd3, 7'b0110011};
        #1;
        check_task(7'b0110011, 5'd3, 3'b000, 5'd1, 5'd2, 7'b0100000);

        // test case 3 - XOR
        instruction = {7'b0000000, 5'd9, 5'd8, 3'b100, 5'd10, 7'b0110011};
        #1;
        check_task(7'b0110011, 5'd10, 3'b100, 5'd8, 5'd9, 7'b0000000);

        // test case 4 - I-i addi
        instruction = {12'd5, 5'd0, 3'b000, 5'd1, 7'b0010011};
        #1;
        check_i_task(7'b0010011, 5'd1, 3'b000, 5'd0);

        // test case 5 - addi with -1
        instruction = {12'b111111111111, 5'd6, 3'b000, 5'd5, 7'b0010011};
        #1;
        check_i_task(7'b0010011, 5'd5, 3'b000, 5'd6);

        // test case 6 - load word
        instruction = {12'd8, 5'd2, 3'b010, 5'd4, 7'b0000011};
        #1;
        check_i_task(7'b0000011, 5'd4, 3'b010, 5'd2);

        // test case 7 - store word
        instruction = {7'b0000000, 5'd7, 5'd3, 3'b010, 5'b01100, 7'b0100011};
        #1;
        check_task(7'b0100011, 5'b01100, 3'b010, 5'd3, 5'd7, 7'b0000000);

        tb_final_display("instruction_field_decoder");

        $finish;
    end
endmodule
