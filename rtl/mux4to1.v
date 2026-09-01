module mux4to1 (input a, b, c, d, input [1:0] sel, output out);
    assign out = (~sel[1] & ~sel[0] & a) | (~sel[1] & sel[0] & b) | (sel[1] & ~sel[0] & c) | (sel[1] & sel[0] & d);
endmodule
