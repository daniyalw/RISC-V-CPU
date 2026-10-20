# 32-bit RISC-V CPU (RV32I Subset)

A from-scratch, single-cycle 32-bit RISC-V processor implemented in Verilog. The core integrates instruction fetch and decoding, register-file access, ALU execution, data memory, and next-PC selection to execute programs assembled from RISC-V assembly. The design is verified using self-checking Verilog testbenches, Icarus Verilog, and GTKWave. It implements a subset of RV32I rather than the complete ISA.

## Features

- Single-cycle CPU core with a program counter, sequential `PC + 4` execution, and control-flow redirection.
- 32 x 32-bit general-purpose register file with hardwired `x0`.
- Instruction field decoding and immediate generation for I, S, B, U, and J formats.
- 32-bit arithmetic/logic operations and signed/unsigned set-less-than comparisons.
- All six RV32I conditional branch instructions, including signed and unsigned comparisons.
- `jal` and `jalr` jumps, including link-register writeback; `jalr` clears bit 0 of its target address.
- `lui` and `auipc` upper-immediate operations.
- Data memory reads and writes (`lw`, `sw`).
- Module-level and CPU-level testbenches with VCD waveform output.

## Supported instructions

| Category | Instructions |
| --- | --- |
| Register arithmetic and logic (R-type) | `add`, `sub`, `and`, `or`, `xor` |
| Register comparisons (R-type) | `slt`, `sltu` |
| Immediate arithmetic and logic (I-type) | `addi`, `andi`, `ori`, `xori` |
| Immediate comparisons (I-type) | `slti`, `sltiu` |
| Conditional branches (B-type) | `beq`, `bne`, `blt`, `bltu`, `bge`, `bgeu` |
| Jumps | `jal`, `jalr` |
| Upper immediates (U-type) | `lui`, `auipc` |
| Word memory operations | `lw`, `sw` |

Shift instructions, byte/halfword memory operations, system/CSR instructions, and other RV32I instructions are not currently implemented.

## Repository layout

```text
rtl/          Verilog modules: CPU core, datapath, decoder, ALU, register file, memories, etc.
tb/           Module-level and CPU integration testbenches
programs/     RISC-V assembly example and linker script
tools/        Binary-to-hex conversion utility
Makefile      Simulation, assembly, waveform, and cleanup targets
build/        Generated simulation and assembly artifacts
waves/        Generated VCD waveform files
```

## Tools

- Icarus Verilog (`iverilog`, `vvp`) for simulation.
- GTKWave for inspecting generated VCD files.
- GNU Make for build and simulation automation. The Makefile was developed and tested on Windows; modifications may be required for other operating systems.
- RISC-V GNU binutils with the `riscv-none-elf-` prefix (`as`, `ld`, `objcopy`, `objdump`) to build the example assembly program.
- Python 3 to convert the assembled binary into a `$readmemh`-compatible hex file.

If your toolchain uses a different RISC-V prefix, adjust `RISCVELF` in the Makefile.

## Build and run

From the repository root, first assemble the example program and generate the instruction-memory hex file:

```sh
make test_hex
```

The `test_hex` target assembles `programs/test.S`, links it at address `0x00000000` using `programs/link.ld`, converts the ELF to a flat binary, and writes `programs/test.hex` using `tools/bin_to_hex.py`.

Then simulate the full CPU:

```sh
make cpu_core
```

To run the collection of component and integration test targets:

```sh
make test
```

To inspect a module waveform (e.g., pc_plus_4):

```sh
make wave_pc_plus_4
```

For an assembly disassembly after `make test_hex`:

```sh
make test_objdump
```

Note: `programs/test.hex` is generated rather than checked in. Run `make test_hex` before `make cpu_core` or `make test` on a fresh checkout. The current Makefile expects the `build/` and `waves/` directories to exist.

## Program execution

Instruction memory is a 32-word array initialized by:

```verilog
$readmemh("programs/test.hex", memory);
```

The program counter starts at `0x00000000`. The instruction-memory address is word-indexed using `address[31:2]`; the hex conversion script emits 32-bit instruction words in the expected order.

The current `programs/test.S` exercises signed and unsigned set-less-than instructions (`slt`, `sltu`, `slti`, `sltiu`) with positive and negative operands. The CPU integration testbench checks the expected results as the program executes.

## Verification

The repository includes self-checking testbenches for individual building blocks and integrated modules, including:

- Arithmetic and logic components (adders, ALUs, multiplexers).
- Program counter and PC sequencing.
- Register file, instruction decoder, immediate generator, and control decoder.
- Instruction and data memories.
- Single-cycle datapath and complete CPU core.

Testbenches check actual values against expected results and report errors; VCD output can be inspected with GTKWave.
