module add_sub_4bit (input [3:0] a, b, input sub, output [3:0] results, output cout);
    wire [3:0] b_modified;

    assign b_modified = b ^ {4{sub}};

    ripple_carry_4bit adder (.a(a), .b(b_modified), .cin(sub), .sum(results), .cout(cout));
endmodule
