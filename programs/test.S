.section .text
.globl _start

_start:
    auipc x1, 0x00001     # PC=0x00, x1 = 0x00000000 + 0x00001000 = 0x00001000
    addi  x2, x1, 4       # x2 = 0x00001004, proves x1 was written

    auipc x3, 0x00002     # PC=0x08, x3 = 0x00000008 + 0x00002000 = 0x00002008
    addi  x4, x3, 8       # x4 = 0x00002010

    auipc x5, 0xfffff     # PC=0x10, x5 = 0x00000010 + 0xfffff000 = 0xfffff010
    addi  x6, x5, -1      # x6 = 0xfffff00f

    .word 0x00000000
