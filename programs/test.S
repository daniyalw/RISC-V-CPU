.section .text
.globl _start

_start:
    addi x1, x0, -5      # x1 = -5
    addi x2, x0, 3       # x2 = 3

    blt  x1, x2, less    # should branch because -5 < 3
    addi x3, x0, 99      # should be skipped

less:
    addi x3, x0, 42      # should execute

    blt  x2, x1, wrong   # should NOT branch because 3 < -5 is false
    addi x4, x0, 7       # should execute

wrong:
    .word 0x00000000
