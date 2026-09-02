module alu_32bit (input [31:0] a, b, input [2:0] op, output [31:0] result, output zero, cout);
    // internal wires
    wire [31:0] adder_result;
    wire adder_cout;

    wire [31:0] sub_result;
    wire sub_cout;

    wire [31:0] and_result;
    wire [31:0] or_result;
    wire [31:0] xor_result;

    wire [31:0] invalid_result;

    // operations
    assign {adder_cout, adder_result} = a + b;

    assign sub_result = a + ~b + 1;
    assign sub_cout = (a >= b);

    assign and_result = a & b;
    assign or_result = a | b;
    assign xor_result = a ^ b;

    assign invalid_result = {32{1'b0}};

    // result mux's
    wire [31:0] mux1_out;
    wire [31:0] mux2_out;

    mux4to1_32bit mux1 (.a(adder_result), .b(sub_result), .c(and_result), .d(or_result), .sel(op[1:0]), .out(mux1_out));
    mux4to1_32bit mux2 (.a(xor_result), .b(invalid_result), .c(invalid_result), .d(invalid_result), .sel(op[1:0]), .out(mux2_out));

    mux2to1_32bit mux3 (.a(mux1_out), .b(mux2_out), .sel(op[2]), .out(result));

    // get zero
    assign zero = (result == {32{1'b0}});

    // cout mux
    wire mux4_cout;

    mux2to1 mux4 (.a(adder_cout), .b(sub_cout), .sel(op[0]), .out(mux4_cout));
    assign cout = ((op == 3'b000) || (op == 3'b001)) ? mux4_cout : 1'b0;
endmodule
