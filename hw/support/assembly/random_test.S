.section .text
.globl _start

_start:
    li   x31, 0              # status: 0=PASS, 1=FAIL

    # seed
    li   x5,  0x12345678

    # pseudo-random mix (unrolled, no loop)
    slli x6,  x5, 13
    xor  x5,  x5, x6
    srli x6,  x5, 17
    xor  x5,  x5, x6
    slli x6,  x5, 5
    xor  x5,  x5, x6          # x5 = rng result

    # random-like instruction coverage
    addi x7,  x5, 0
    xori x8,  x5, 0x5A5
    andi x9,  x5, 31

    add  x10, x7,  x8
    sub  x11, x8,  x7
    xor  x12, x10, x11
    or   x13, x12, x8
    and  x14, x13, x7

    sll  x15, x14, x9
    srl  x16, x15, x9
    sra  x17, x15, x9

    slt  x18, x17, x16
    sltu x19, x15, x14

    # signature accumulation
    li   x20, 0
    add  x20, x20, x10
    xor  x20, x20, x11
    add  x20, x20, x12
    xor  x20, x20, x17
    add  x20, x20, x18
    xor  x20, x20, x19

    # expected signature (fixed)
    li   x21, 0x6F3C9A2E
    bne  x20, x21, fail

    j    END

fail:
    li   x31, 1

END:
