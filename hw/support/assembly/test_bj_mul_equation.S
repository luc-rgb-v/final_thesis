.section .text
.globl _start

_start:
    addi x11, x0, 7      # A = 7
    addi x12, x0, 5      # B = 5
    addi x13, x0, 3      # C = 3

    la   x20, add_func
    jalr x1, x20, 0     # x10 = add(x11, x12)

    la   x20, mul_func
    jalr x1, x20, 0     # x10 = mul(x10, x13)

    jal x0, end

add_func:
    add x10, x11, x12
    jalr x0, x1, 0

mul_func:
    addi x14, x0, 0     # acc = 0
    addi x15, x0, 0     # i = 0

mul_loop:
    beq  x15, x13, mul_done
    add  x14, x14, x10
    addi x15, x15, 1
    jal  x0, mul_loop

mul_done:
    add x10, x14, x0
    jalr x0, x1, 0

end:
    nop
