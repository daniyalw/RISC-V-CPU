.section .text
.globl _start

_start:
    lui  x1, 0x2
    addi x2, x0, 51
    sw   x2, 0(x1)

    loop:
        jal x0, loop
