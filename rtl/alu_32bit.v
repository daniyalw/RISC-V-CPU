module alu_32bit (input [31:0] a, b, input [3:0] op, output [31:0] result, output zero, cout);
    /* OPs:
        0000: ADD/ADDI
        0001: SUB
        0010: AND/ANDI
        0011: OR/ORI
        0100: XOR/XORI
        0101: SLT/SLTI (NEW)
        0110: SLTU/SLTIU (NEW)
        0111: SLL/SLLI (NEW)
        1000: SRL/SRLI (NEW)
        1001: SRA/SRAI (NEW)
        1010:
        1011:
        1100:
        1101:
        1110:
        1111: UNUSED
    */

    // internal wires
    wire [31:0] adder_result;
    wire adder_cout;

    wire [31:0] sub_result;
    wire sub_cout;

    wire [31:0] and_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;

    wire [31:0] sll_result;
    wire [31:0] slt_result;
    wire [31:0] sltu_result;
    wire [31:0] srl_result;
    wire [31:0] sra_result;

    wire [31:0] invalid_result;

    // operations
    assign {adder_cout, adder_result} = a + b;

    assign sub_result = a + ~b + 1;
    assign sub_cout = (a >= b);

    assign and_result = a & b;
    assign or_result = a | b;
    assign xor_result = a ^ b;

    assign sll_result = a << b[4:0]; // SLL/SLLI, [4:0] is used to ensure the 5 LSB bits are used, 2^5 = 32 so no shifting beyond 32
    assign slt_result = $signed(a) < $signed(b); // SLT, or SLTI
    assign sltu_result = $unsigned(a) < $unsigned(b); // SLTU, or SLTIU
    assign srl_result = a >> b[4:0]; // SRL/SRLI, [4:0] is used to ensure the 5 LSB bits are used, 2^5 = 32 so no shifting beyond 32
    assign sra_result = $signed(a) >>> b[4:0];

    assign invalid_result = {32{1'b0}};

    // result mux's
    wire [31:0] mux1_out;
    wire [31:0] mux2_out;
    wire [31:0] mux3_out;
    wire [31:0] mux4_out;

    // remember that 3'b111 is the "invalid" opcode, for when I deliberately need to set the opcode to invalid in the control decoder

    mux4to1_32bit mux1 (.a(adder_result), .b(sub_result), .c(and_result), .d(or_result), .sel(op[1:0]), .out(mux1_out));
    mux4to1_32bit mux2 (.a(xor_result), .b(slt_result), .c(sltu_result), .d(sll_result), .sel(op[1:0]), .out(mux2_out));
    mux4to1_32bit mux3 (.a(srl_result), .b(sra_result), .c(invalid_result), .d(invalid_result), .sel(op[1:0]), .out(mux3_out));
    mux4to1_32bit mux4 (.a(invalid_result), .b(invalid_result), .c(invalid_result), .d(invalid_result), .sel(op[1:0]), .out(mux4_out));

    mux4to1_32bit mux5 (.a(mux1_out), .b(mux2_out), .c(mux3_out), .d(mux4_out), .sel(op[3:2]), .out(result));

    // get zero
    assign zero = (result == {32{1'b0}});

    // cout mux
    wire mux6_cout;

    mux2to1 mux6 (.a(adder_cout), .b(sub_cout), .sel(op[0]), .out(mux6_cout));
    assign cout = ((op == 3'b000) || (op == 3'b001)) ? mux6_cout : 1'b0;
endmodule
