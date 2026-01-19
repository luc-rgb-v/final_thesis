.section .text
.globl _start

_start:
    addi x2, x0, 0
    addi x3, x0, 0
    addi x4, x0, 0
    addi x5, x0, 0
    addi x6, x0, 0
    addi x7, x0, 0

    addi x1, x0, -5

loop:
    blt  x1, x0, neg
    beq  x1, x0, zer
    bge  x1, x0, pos

neg:
    addi x2, x2, 1
    jal  x0, odd_even

zer:
    addi x3, x3, 1
    jal  x0, odd_even

pos:
    addi x4, x4, 1

odd_even:
    andi x8, x1, 1
    beq  x8, x0, even
    bne  x8, x0, odd

even:
    addi x6, x6, 1
    jal  x0, uns

odd:
    addi x5, x5, 1

uns:
    bltu x1, x0, ubig
    jal  x0, step

ubig:
    addi x7, x7, 1

step:
    addi x1, x1, 1
    addi x9, x0, 6
    blt  x1, x9, loop

end:
    nop
