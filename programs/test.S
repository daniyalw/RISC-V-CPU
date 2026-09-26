.section .text
.globl _start

_start:
    addi x5, x0, 17      # x5 = 17; JALR should clear bit 0, so target becomes 16
    jalr x6, 0(x5)       # x6 = PC + 4 = 8, PC = (17 + 0) & ~1 = 16

    addi x1, x0, 99      # should be skipped
    addi x1, x0, 88      # should also be skipped

target:
    addi x2, x0, 42      # should execute
    addi x3, x6, 0       # x3 = 8, proves JALR wrote return address to x6

    .word 0x00000000
