.section .text
.globl _start

_start:
    li   x1, 13
    li   x2, 7
    li   x3, 0

LOOP:
    andi x4, x2, 1
    beq  x4, x0, SKIP
    add  x3, x3, x1

SKIP:
    slli x1, x1, 1
    srli x2, x2, 1
    bne  x2, x0, LOOP

END:
