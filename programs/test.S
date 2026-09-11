.section .text
.globl _start

_start:
    addi x1, x0, 12
    andi x2, x1, 10
    ori  x3, x2, 3
    xori x4, x3, 15
    add  x5, x4, x1
    sub  x6, x5, x2

.word 0x00000000
