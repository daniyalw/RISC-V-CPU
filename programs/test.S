.section .text
.globl _start

_start:
    addi x1, x0, -5        # x1 = -5 = 0xfffffffb
    addi x2, x0, 3         # x2 = 3
    addi x3, x0, -1        # x3 = -1 = 0xffffffff
    addi x4, x0, 1         # x4 = 1

    # SLT
    slt  x5, x1, x2        # -5 < 3 signed -> x5 = 1
    slt  x6, x2, x1        # 3 < -5 signed -> x6 = 0

    # SLTU
    sltu x7, x3, x4        # 0xffffffff < 1 unsigned -> x7 = 0
    sltu x8, x4, x3        # 1 < 0xffffffff unsigned -> x8 = 1

    # SLTI
    slti x9,  x1, 0        # -5 < 0 signed -> x9 = 1
    slti x10, x2, 0        # 3 < 0 signed -> x10 = 0

    # SLTIU
    sltiu x11, x3, 1       # 0xffffffff < 1 unsigned -> x11 = 0
    sltiu x12, x4, -1      # 1 < 0xffffffff unsigned -> x12 = 1

    .word 0x00000000
