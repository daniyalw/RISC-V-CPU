module data_memory (input clk, reset, mem_write, mem_read, input [31:0] address, write_data, output reg [31:0] out_data);
    // write_data is 32-bit data, whereas mem_write is a 1-bit toggle for whether or not to write what's in write_data to the data memory
    reg [31:0] datamem [0:31];
    integer i;

    always @(posedge clk or posedge reset) begin
        // reset
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                datamem[i] = 32'd0;
            end
        end
        
        // sw
        if (mem_write == 1) begin
            datamem[address[31:2]] <= write_data;
        end
    end

    always @(*) begin
        // lw
        if (mem_read == 1) begin
            out_data = datamem[address[31:2]];
        end else begin
            out_data = 32'd0;
        end
    end
endmodule
