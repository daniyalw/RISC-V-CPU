.section .text
.globl _start

_start:
    addi x1, x0, 0      # base address
    addi x2, x0, 42     # value to store
    sw   x2, 0(x1)      # memory[0] = 42
    lw   x3, 0(x1)      # x3 = memory[0]
    addi x4, x3, 1      # proves x3 became 42
    .word 0x00000000
