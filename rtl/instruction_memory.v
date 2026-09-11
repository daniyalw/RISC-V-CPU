module instruction_memory (input [31:0] address, output reg [31:0] instruction);
    reg [31:0] memory[0:31]; // according to the compiler I should do 0:31 instead of 31:0 to avoid ambiguity
    integer i;

    initial begin
        $readmemh("programs/test.hex", memory); // read file into memory and leave the rest zeroed
    end

    always @(*) begin
        if (address[31:2] < 32) // ensure no out-of-bound PC value
            instruction = memory[address[31:2]];
        else
            instruction = 32'h00000000;
    end
endmodule
