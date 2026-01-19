.section .text
.globl _start

_start:
    li   x31, 0            # failmask (0=PASS)

    # T0: 0x1234 / 0 => q=0xFFFFFFFF r=0x1234
    li   x10, 0x1234
    li   x11, 0
    jal  x1, divu32
    li   x14, -1
    li   x15, 0x1234
    li   x16, 0
    jal  x1, chk

    # T1: 0xFFFFFFFF / 0xFFFFFFFF => q=1 r=0
    li   x10, -1
    li   x11, -1
    jal  x1, divu32
    li   x14, 1
    li   x15, 0
    li   x16, 1
    jal  x1, chk

    # T2: 0x80000000 / 2 => q=0x40000000 r=0
    li   x10, 0x80000000
    li   x11, 2
    jal  x1, divu32
    li   x14, 0x40000000
    li   x15, 0
    li   x16, 2
    jal  x1, chk

    # T3: 0x80000000 / 3 => q=0x2AAAAAAA r=2
    li   x10, 0x80000000
    li   x11, 3
    jal  x1, divu32
    li   x14, 0x2AAAAAAA
    li   x15, 2
    li   x16, 3
    jal  x1, chk

    # T4: 0x80000001 / 0x80000000 => q=1 r=1
    li   x10, 0x80000001
    li   x11, 0x80000000
    jal  x1, divu32
    li   x14, 1
    li   x15, 1
    li   x16, 4
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

