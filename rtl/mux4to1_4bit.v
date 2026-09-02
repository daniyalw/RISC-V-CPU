module mux4to1_4bit (input [3:0] a, b, c, d, input [1:0] sel, output [3:0] out);
    assign out = ({4{~sel[1] & ~sel[0]}} & a) | ({4{~sel[1] & sel[0]}} & b) | ({4{sel[1] & ~sel[0]}} & c) | ({4{sel[1] & sel[0]}} & d);
endmodule
