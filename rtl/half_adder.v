module half_adder (input a, b, output sum, carry);
    assign sum = a ^ b; // XOR
    assign carry = a & b; // AND
endmodule
