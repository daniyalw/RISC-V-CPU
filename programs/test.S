.section .text
.globl _start

_start:
    # BGE signed tests

    addi x1, x0, -5        # x1 = -5
    addi x2, x0, 3         # x2 = 3

    bge  x1, x2, wrong1    # -5 >= 3 is false, should NOT branch
    addi x3, x0, 11        # should execute

    bge  x2, x1, bge_ok    # 3 >= -5 is true, should branch
    addi x3, x0, 99        # should be skipped

bge_ok:
    addi x4, x0, 22        # should execute

    # BGEU unsigned tests

    addi x5, x0, -1        # x5 = 0xffffffff unsigned = huge
    addi x6, x0, 1         # x6 = 1

    bgeu x6, x5, wrong2    # 1 >= 0xffffffff unsigned is false, should NOT branch
    addi x7, x0, 33        # should execute

    bgeu x5, x6, bgeu_ok   # 0xffffffff >= 1 unsigned is true, should branch
    addi x7, x0, 99        # should be skipped

bgeu_ok:
    addi x8, x0, 44        # should execute

wrong1:
wrong2:
    .word 0x00000000
