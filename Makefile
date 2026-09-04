# tools
IVERILOG = iverilog
VVP      = vvp
GTKWAVE  = gtkwave

# directories
RTL_DIR   = rtl
TB_DIR    = tb
BUILD_DIR = build
WAVE_DIR  = waves

# default target
all: mux2to1 mux4to1 half_adder full_adder ripple_carry_4bit add_sub_4bit mux4to1_4bit mux2to1_4bit alu_4bit mux2to1_32bit mux4to1_32bit alu_32bit register_32bit pc_plus_4 tb_pc_flow register_file instruction_field_decoder

##############################################
# individual simulation targets
##############################################

mux2to1: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/mux2to1.out \
		$(RTL_DIR)/mux2to1.v \
		$(TB_DIR)/tb_mux2to1.v
	$(VVP) $(BUILD_DIR)/mux2to1.out

mux4to1: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/mux4to1.out \
		$(RTL_DIR)/mux4to1.v \
		$(TB_DIR)/tb_mux4to1.v
	$(VVP) $(BUILD_DIR)/mux4to1.out

half_adder: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/half_adder.out \
		$(RTL_DIR)/half_adder.v \
		$(TB_DIR)/tb_half_adder.v
	$(VVP) $(BUILD_DIR)/half_adder.out

full_adder: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/full_adder.out \
		$(RTL_DIR)/full_adder.v \
		$(TB_DIR)/tb_full_adder.v
	$(VVP) $(BUILD_DIR)/full_adder.out

ripple_carry_4bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/ripple_carry_4bit.out \
		$(RTL_DIR)/full_adder.v \
		$(RTL_DIR)/ripple_carry_4bit.v \
		$(TB_DIR)/tb_ripple_carry_4bit.v
	$(VVP) $(BUILD_DIR)/ripple_carry_4bit.out

add_sub_4bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/add_sub_4bit.out \
		$(RTL_DIR)/full_adder.v \
		$(RTL_DIR)/ripple_carry_4bit.v \
		$(RTL_DIR)/add_sub_4bit.v \
		$(TB_DIR)/tb_add_sub_4bit.v
	$(VVP) $(BUILD_DIR)/add_sub_4bit.out

mux4to1_4bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/mux4to1_4bit.out \
		$(RTL_DIR)/mux4to1_4bit.v \
		$(TB_DIR)/tb_mux4to1_4bit.v
	$(VVP) $(BUILD_DIR)/mux4to1_4bit.out

mux2to1_4bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/mux2to1_4bit.out \
		$(RTL_DIR)/mux2to1_4bit.v \
		$(TB_DIR)/tb_mux2to1_4bit.v
	$(VVP) $(BUILD_DIR)/mux2to1_4bit.out

alu_4bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/alu_4bit.out \
		$(RTL_DIR)/alu_4bit.v \
		$(RTL_DIR)/add_sub_4bit.v \
		$(RTL_DIR)/mux4to1_4bit.v \
		$(RTL_DIR)/mux2to1_4bit.v \
		$(RTL_DIR)/mux2to1.v \
		$(RTL_DIR)/ripple_carry_4bit.v \
		$(RTL_DIR)/full_adder.v \
		$(TB_DIR)/tb_alu_4bit.v
	$(VVP) $(BUILD_DIR)/alu_4bit.out

mux2to1_32bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/mux2to1_32bit.out \
		$(RTL_DIR)/mux2to1_32bit.v \
		$(TB_DIR)/tb_mux2to1_32bit.v
	$(VVP) $(BUILD_DIR)/mux2to1_32bit.out

mux4to1_32bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/mux4to1_32bit.out \
		$(RTL_DIR)/mux4to1_32bit.v \
		$(TB_DIR)/tb_mux4to1_32bit.v
	$(VVP) $(BUILD_DIR)/mux4to1_32bit.out

alu_32bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/alu_32bit.out \
		$(RTL_DIR)/alu_32bit.v \
		$(RTL_DIR)/mux4to1_32bit.v \
		$(RTL_DIR)/mux2to1_32bit.v \
		$(RTL_DIR)/mux2to1.v \
		$(TB_DIR)/tb_alu_32bit.v
	$(VVP) $(BUILD_DIR)/alu_32bit.out

register_32bit: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/register_32bit.out \
		$(RTL_DIR)/register_32bit.v \
		$(TB_DIR)/tb_register_32bit.v
	$(VVP) $(BUILD_DIR)/register_32bit.out

pc_plus_4: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/pc_plus_4.out \
		$(RTL_DIR)/pc_plus_4.v \
		$(TB_DIR)/tb_pc_plus_4.v
	$(VVP) $(BUILD_DIR)/pc_plus_4.out

tb_pc_flow: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/tb_pc_flow.out \
		$(RTL_DIR)/program_counter.v \
		$(RTL_DIR)/register_32bit.v \
		$(RTL_DIR)/pc_plus_4.v \
		$(TB_DIR)/tb_pc_flow.v
	$(VVP) $(BUILD_DIR)/tb_pc_flow.out

register_file: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/register_file.out \
		$(RTL_DIR)/register_file.v \
		$(TB_DIR)/tb_register_file.v
	$(VVP) $(BUILD_DIR)/register_file.out

instruction_field_decoder: $(BUILD_DIR) $(WAVE_DIR)
	$(IVERILOG) -o $(BUILD_DIR)/instruction_field_decoder.out \
		$(RTL_DIR)/instruction_field_decoder.v \
		$(TB_DIR)/tb_instruction_field_decoder.v
	$(VVP) $(BUILD_DIR)/instruction_field_decoder.out

##############################################
# open waveforms
##############################################

wave_mux2to1:
	$(GTKWAVE) $(WAVE_DIR)/mux2to1.vcd

wave_mux4to1:
	$(GTKWAVE) $(WAVE_DIR)/mux4to1.vcd

wave_half_adder:
	$(GTKWAVE) $(WAVE_DIR)/half_adder.vcd

wave_full_adder:
	$(GTKWAVE) $(WAVE_DIR)/full_adder.vcd

wave_ripple_carry_4bit:
	$(GTKWAVE) $(WAVE_DIR)/ripple_carry_4bit.vcd

wave_add_sub_4bit:
	$(GTKWAVE) $(WAVE_DIR)/add_sub_4bit.vcd

wave_mux4to1_4bit:
	$(GTKWAVE) $(WAVE_DIR)/mux4to1_4bit.vcd

wave_mux2to1_4bit:
	$(GTKWAVE) $(WAVE_DIR)/mux2to1_4bit.vcd

wave_alu_4bit:
	$(GTKWAVE) $(WAVE_DIR)/alu_4bit.vcd

wave_mux2to1_32bit:
	$(GTKWAVE) $(WAVE_DIR)/mux2to1_32bit.vcd

wave_mux4to1_32bit:
	$(GTKWAVE) $(WAVE_DIR)/mux4to1_32bit.vcd

wave_alu_32bit:
	$(GTKWAVE) $(WAVE_DIR)/alu_32bit.vcd

wave_register_32bit:
	$(GTKWAVE) $(WAVE_DIR)/register_32bit.vcd

wave_pc_plus_4:
	$(GTKWAVE) $(WAVE_DIR)/pc_plus_4.vcd

wave_tb_pc_flow:
	$(GTKWAVE) $(WAVE_DIR)/tb_pc_flow.vcd

wave_register_file:
	$(GTKWAVE) $(WAVE_DIR)/register_file.vcd

wave_instruction_field_decoder:
	$(GTKWAVE) $(WAVE_DIR)/instruction_field_decoder.vcd

##############################################
# cleanup
##############################################

clean:
	del $(BUILD_DIR)\\*.out
	del $(WAVE_DIR)\\*.vcd

.PHONY: all clean \
	mux2to1 mux4to1 half_adder full_adder ripple_carry_4bit add_sub_4bit mux4to1_4bit mux2to1_4bit alu_4bit mux2to1_32bit mux4to1_32bit alu_32bit register_32bit pc_plus_4 tb_pc_flow register_file instruction_field_decoder \
	wave_mux2to1 wave_mux4to1 wave_half_adder wave_full_adder wave_ripple_carry_4bit wave_add_sub_4bit wave_mux4to1_4bit wave_mux2to1_4bit wave_alu_4bit wave_mux2to1_32bit wave_mux4to1_32bit wave_alu_32bit wave_register_32bit wave_pc_plus_4 wave_tb_pc_flow wave_register_file wave_instruction_field_decoder
