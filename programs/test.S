.section .text
.globl _start

_start:
    lui  x1, 0x12345      # x1 = 0x12345000
    addi x2, x1, 0        # x2 = 0x12345000, proves LUI wrote x1

    lui  x3, 0x00001      # x3 = 0x00001000
    addi x4, x3, 5        # x4 = 0x00001005

    lui  x5, 0xfffff      # x5 = 0xfffff000
    addi x6, x5, -1       # x6 = 0xffffefff

    .word 0x00000000
