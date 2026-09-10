module single_cycle_datapath (input [31:0] instruction, input clk, reset, output [31:0] alu_result, output invalid_instruction);
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [2:0] alu_op;
    wire alu_src, reg_write;
    wire [31:0] rd_data, rs1_data, rs2_data, immediate;
    wire alu_cout;
    wire alu_zero;
    wire [4:0] rd, rs1, rs2;

    instruction_field_decoder ifd (.instruction(instruction), .opcode(opcode), .rd(rd), .funct3(funct3), .rs1(rs1), .rs2(rs2), .funct7(funct7));

    immediate_generator imm (.instruction(instruction), .immediate(immediate));

    control_decoder cd (.opcode(opcode), .funct3(funct3), .funct7(funct7), .alu_op(alu_op), .alu_src(alu_src), .reg_write(reg_write), .invalid_instruction(invalid_instruction));

    register_file rf (.clk(clk), .reset(reset), .write_enable(reg_write), .rs1_addr(rs1), .rs2_addr(rs2), .rd_addr(rd), .rd_data(rd_data), .rs1_data(rs1_data), .rs2_data(rs2_data));

    alu_32bit alu (.a(rs1_data), .b(alu_src ? immediate : rs2_data), .op(alu_op), .result(alu_result), .zero(alu_zero), .cout(alu_cout));
    assign rd_data = alu_result;
endmodule
