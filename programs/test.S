addi x1, x0, 5
jal  x5, target
addi x2, x0, 99      # should be skipped

target:
    addi x3, x0, 42
    addi x4, x5, 0       # x4 should become return address
    .word 0x00000000
