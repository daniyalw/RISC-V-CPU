.section .text
.globl _start

_start:
    lui  x1, 0x2 # GPIO address = 0x2000
    addi x4, x0, 0 # counter

    loop:
        lw   x2, 4(x1) # read button
        andi x3, x2, 1 # extract LSB
        bne  x3, x0, loop # keep polling if not pressed

        addi x4, x4, 1 # increment counter
        sw   x4, 0(x1) # display counter on LEDs

    wait_release:
        lw   x2, 4(x1)
        andi x3, x2, 1
        beq  x3, x0, wait_release # wait if still pressed

        jal  x0, loop
