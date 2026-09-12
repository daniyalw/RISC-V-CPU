# 32-bit RISC-V CPU

A from-scratch RV32I-subset CPU core written in Verilog.

## Current Features

- Single-cycle CPU structure
- Program counter with PC+4 sequencing
- External instruction loading using `$readmemh`
- Register file with 32 registers and hardwired `x0`
- Instruction field decoder
- Immediate generator for I-type and B-type instructions
- 32-bit ALU
- Branch target and branch-taken logic
- Self-checking testbenches with VCD waveform output

## Supported Instructions
### R-type

- `add`
- `sub`
- `and`
- `or`
- `xor`

### I-type

- `addi`
- `andi`
- `ori`
- `xori`

### B-type

- `beq`
- `bne`

## Program Loading

Assembly programs are assembled into machine code, converted into a hex file, and loaded into instruction memory using:

```verilog
$readmemh("programs/test.hex", memory);
```

The CPU starts executing from PC 0x00000000.

## Tests
The project includes testbenches for:
- ALU
- Register file
- Program counter
- Instruction memory
- Immediate generator
- Control decoder
- Single-cycle datapath
- CPU core

## Current Status

The CPU can execute straight-line ALU programs and simple branches using externally loaded RISC-V assembly programs.
