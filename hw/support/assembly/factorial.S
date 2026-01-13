.section .text
.globl _start

_start:
    lui  x10, 0x80010
    lui  x11, 0x80011

    addi x1, x0, 6      # x1 = N = 6
    addi x2, x0, 1      # x2 = i = 1
    addi x3, x0, 1      # x3 = fact = 1

loop:
    addi x4, x0, 0      # temp = 0
    addi x5, x2, 0      # counter = i

mul_loop:
    beq  x5, x0, mul_done
    add  x4, x4, x3
    addi x5, x5, -1
    jal  x0, mul_loop

mul_done:
    addi x3, x4, 0      # fact = temp

    sw   x3, 0(x10)     # store fact
    addi x10, x10, 4

    addi x2, x2, 1      # i++

    slt  x6, x1, x2     # x6 = (N < i)
    beq  x6, x0, loop   # if not (N < i) → loop

end:
