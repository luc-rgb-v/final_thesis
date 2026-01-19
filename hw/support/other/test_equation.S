.section .text
.globl _start

_start:
    lui  x2, 0
    addi x2, x2, 7

    lui  x3, 0
    addi x3, x3, 5

    lui  x4, 0
    addi x4, x4, 3

    la   x5, add_func
    jalr x1, x5, 0

    la   x5, mul_func
    jalr x1, x5, 0

    jal x0, end


add_func:
    add x6, x2, x3
    add x2, x6, x0
    jalr x0, x1, 0


mul_func:
    addi x6, x0, 0
    addi x7, x0, 0
L1:
    beq  x7, x4, L2
    add  x6, x6, x2
    addi x7, x7, 1
    jal  x0, L1
L2:
    add x2, x6, x0
    jalr x0, x1, 0


end:
    nop
