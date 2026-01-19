
#  mean = sum(ir[i]) >> 3;   // N = 8
#  out[i] = -(ir[i] - mean);

.section .text
.globl _start

_start:
    # =================================================
    # Base addresses
    # =================================================
    lui  x1, 0x80000        # x1 = IR buffer base  (0x8000_0000)
    lui  x2, 0x80001        # x2 = OUT buffer base (0x8000_1000)

    # =================================================
    # Initialize IR buffer (store-only)
    # =================================================
    li   x10, 33897
    sw   x10, 0(x1)

    li   x10, 34126
    sw   x10, 4(x1)

    li   x10, 34653
    sw   x10, 8(x1)

    li   x10, 35203
    sw   x10, 12(x1)

    li   x10, 35624
    sw   x10, 16(x1)

    li   x10, 35731
    sw   x10, 20(x1)

    li   x10, 35607
    sw   x10, 24(x1)

    li   x10, 35517
    sw   x10, 28(x1)

    # =================================================
    # Compute mean = sum / 8
    # =================================================
    li   x3, 8              # N = 8
    li   x4, 0              # sum
    li   x5, 0              # index

    lui  x1, 0x80000        # reset IR pointer

sum_loop:
    lw   x6, 0(x1)
    add  x4, x4, x6
    addi x1, x1, 4
    addi x5, x5, 1
    blt  x5, x3, sum_loop

    srai x4, x4, 3          # mean = sum >> 3

    # =================================================
    # DC removal: out[i] = -(IR[i] - mean)
    # =================================================
    lui  x1, 0x80000        # IR pointer
    lui  x2, 0x80001        # OUT pointer
    li   x5, 0              # index

dc_loop:
    lw   x10, 0(x1)         # IR[i]
    sub  x6,  x10, x4       # IR - mean
    sub  x6,  x0,  x6       # negate
    sw   x6,  0(x2)

    addi x1, x1, 4
    addi x2, x2, 4
    addi x5, x5, 1
    blt  x5, x3, dc_loop

end:
    nop
