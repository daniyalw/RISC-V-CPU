module mux2to1 (input a, b, sel, output out);
    assign out = (~sel & a) | (sel & b);
endmodule
