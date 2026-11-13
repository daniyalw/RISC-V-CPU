# 32-bit RISC-V CPU (RV32I Subset)

A from-scratch, single-cycle 32-bit RISC-V processor implemented in Verilog. The core integrates instruction fetch and decoding, register-file access, ALU execution, data memory, and next-PC selection to execute programs assembled from RISC-V assembly. The design is verified using self-checking Verilog testbenches, Icarus Verilog, and GTKWave. It implements a subset of RV32I rather than the complete ISA.

Implemented and tested on the Tang Nano 9k FPGA, reading a physical GPIO pushbutton and controlling six LEDs.

## FPGA Demonstration

The processor has been synthesized and implemented on the Sipeed Tang Nano 9K FPGA (Gowin GW1NR-9C), using the onboard 27 MHz clock. The current demonstration runs a RISC-V assembly program that implements a button-controlled binary counter:

1. The CPU reads the physical pushbutton through memory-mapped GPIO using `lw`.
2. A two-stage synchronizer and hardware debouncer provide a stable button signal.
3. The program uses `andi` and conditional branches to detect button presses.
4. Each press increments a counter stored in a general-purpose register.
5. The counter is displayed on the six onboard LEDs using `sw`.

The program waits for the button to be released before accepting another press.

The design uses separate instruction and data memories, with an SoC interconnect handling memory-mapped peripheral access.

_Demonstration video: coming soon._

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
- Memory-mapped LED output GPIO.
- Memory-mapped pushbutton input GPIO.
- Two-stage input synchronizer.
- Counter-based hardware debouncing with a 10 ms interval at 27 MHz.
- Address decoding and read-data multiplexing through an SoC interconnect.

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
fpga/         Tang Nano 9K top-level module, Gowin project,
              pin constraints, timing constraints, and FPGA program
build/        Generated build artifacts (Git-ignored)
waves/        Generated VCD waveforms (Git-ignored)
```

## Memory Map

| Address | Component | Access |
| --- | --- | --- |
| `0x0000–0x007F` | Data RAM | RW |
| `0x2000` | LED GPIO | W |
| `0x2004` | Button GPIO | R |
| `0x3000–0x3FFF` | Reserved for UART | - |
| `0x4000–0x4FFF` | Reserved for Timer | - |

## Tools

- Icarus Verilog (`iverilog`, `vvp`) for simulation.
- GTKWave for inspecting generated VCD files.
- GNU Make for build and simulation automation. The Makefile was developed and tested on Windows; modifications may be required for other operating systems.
- RISC-V GNU binutils with the `riscv-none-elf-` prefix (`as`, `ld`, `objcopy`, `objdump`) to build the example assembly program.
- Python 3 to convert the assembled binary into a `$readmemh`-compatible hex file.
- Gowin EDA for FPGA synthesis, PNR, and bitstream generation.
- openFPGALoader for programming the FPGA.

If your toolchain uses a different RISC-V prefix, adjust `RISCVELF` in the Makefile.

## Build and run

From the repository root, create the build/ and waves/ directories if they do not already exist.

Assemble the example program and generate the instruction-memory hex file:

```sh
make test_hex
```

The `test_hex` target assembles `programs/test.S`, links it at address `0x00000000` using `programs/link.ld`, converts the ELF to a flat binary, and writes `programs/test.hex` using `tools/bin_to_hex.py`. The `make test_led` target assembles `programs/basic_led.S` and generates the HEX file used for the FPGA demonstration.

Run the CPU integration test:

```sh
make cpu_core
```

Run the button GPIO testbench:

```sh
make button_gpio
```

Run the SoC interconnect testbench:

```sh
make soc_interconnect
```

Assemble the button/LED GPIO test program:

```sh
make test_led
```

Open the button GPIO waveform:

```sh
make wave_button_gpio
```

The repository also includes a `make test` target for running a collection of component and integration tests.

Note: The instruction-memory RTL currently uses `$readmemh("basic_led.hex", memory)`. The HEX file must be accessible from the simulator or synthesis tool's working directory.

## Program execution

Instruction memory is a 32-word array initialized by:

```verilog
$readmemh("basic_led.hex", memory);
```

The program counter starts at `0x00000000`. The instruction-memory address is word-indexed using `address[31:2]`; the hex conversion script emits 32-bit instruction words in the expected order.

## FPGA Build

The Tang Nano 9K FPGA project is located at `fpga/tang_nano_9k/fpga_project/`.

1. Open `fpga_project.gprj` in Gowin EDA.
2. Generate the FPGA demonstration program using `make test_led` from repository root.
3. Ensure the generated `basic_led.hex` is copied to the Gowin project's `src/` directory.
4. Run synthesis and place-and-route, then generate the bitstream.
5. Program the Tang Nano 9K using openFPGALoader or Gowin Programmer.

The Gowin project uses relative paths for its RTL sources and constraints. The FPGA design uses the onboard 27 MHz clock, with one pushbutton assigned to reset and the other to GPIO input.

**Note:** During development on Windows, I encountered a `KERNEL_SECURITY_CHECK_FAILURE` blue-screen error while using Gowin Programmer. I subsequently used openFPGALoader to program the FPGA successfully. The underlying cause of the crash has not been determined.

## Verification

The repository includes self-checking testbenches for individual building blocks and integrated modules, including:

- Arithmetic and logic components (adders, ALUs, multiplexers).
- Program counter and PC sequencing.
- Register file, instruction decoder, immediate generator, and control decoder.
- Instruction and data memories.
- Single-cycle datapath and complete CPU core.

Testbenches check actual values against expected results and report errors; VCD output can be inspected with GTKWave.
