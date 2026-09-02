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
all: mux2to1 mux4to1 half_adder full_adder ripple_carry_4bit add_sub_4bit mux4to1_4bit mux2to1_4bit alu_4bit mux2to1_32bit

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

##############################################
# cleanup
##############################################

clean:
	del $(BUILD_DIR)\\*.out
	del $(WAVE_DIR)\\*.vcd

.PHONY: all clean \
	mux2to1 mux4to1 half_adder full_adder ripple_carry_4bit add_sub_4bit mux4to1_4bit mux2to1_4bit alu_4bit mux2to1_32bit \
	wave_mux2to1 wave_mux4to1 wave_half_adder wave_full_adder wave_ripple_carry_4bit wave_add_sub_4bit wave_mux4to1_4bit wave_mux2to1_4bit wave_alu_4bit wave_mux2to1_32bit
