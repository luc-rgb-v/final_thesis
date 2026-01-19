.section .text
.globl _start

_start:
    li   x31, 0

    li   x10, 13
    li   x11, 7
    jal  x1, divu32
    li   x14, 1
    li   x15, 6
    li   x16, 0
    jal  x1, chk

    li   x10, 0
    li   x11, 7
    jal  x1, divu32
    li   x14, 0
    li   x15, 0
    li   x16, 1
    jal  x1, chk

    li   x10, 7
    li   x11, 13
    jal  x1, divu32
    li   x14, 0
    li   x15, 7
    li   x16, 2
    jal  x1, chk

    li   x10, 255
    li   x11, 2
    jal  x1, divu32
    li   x14, 127
    li   x15, 1
    li   x16, 3
    jal  x1, chk

    li   x10, -1
    li   x11, 16
    jal  x1, divu32
    li   x14, 0x0FFFFFFF
    li   x15, 0xF
    li   x16, 4
    jal  x1, chk

    li   x10, 0x1234
    li   x11, 0
    jal  x1, divu32
    li   x14, -1
    li   x15, 0x1234
    li   x16, 5
    jal  x1, chk

    j    END


chk:
    bne  x12, x14, 1f
    bne  x13, x15, 1f
    jalr x0, 0(x1)
1:
    li   x5, 1
    sll  x5, x5, x16
    or   x31, x31, x5
    jalr x0, 0(x1)


divu32:
    beq  x11, x0, .div0
    li   x12, 0
    li   x13, 0
    li   x5,  31
.L:
    srl  x6,  x10, x5
    andi x6,  x6,  1
    slli x13, x13, 1
    or   x13, x13, x6
    sltu x7,  x13, x11
    bne  x7,  x0,  .S
    sub  x13, x13, x11
    li   x28, 1
    sll  x28, x28, x5
    or   x12, x12, x28
.S:
    addi x5, x5, -1
    bge  x5, x0, .L
    jalr x0, 0(x1)
.div0:
    li   x12, -1
    addi x13, x10, 0
    jalr x0, 0(x1)


END:

