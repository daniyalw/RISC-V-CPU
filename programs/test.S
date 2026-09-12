.section .text
.globl _start

_start:
    addi x1, x0, 5
    addi x2, x0, 5
    beq  x1, x2, equal
    addi x3, x0, 99      # should be skipped

equal:
    addi x3, x0, 42
    bne  x1, x2, wrong   # should not branch
    addi x4, x0, 7

wrong:
    .word 0x00000000
