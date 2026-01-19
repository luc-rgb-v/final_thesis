.section .text
.globl _start

_start:
    li   x5, 15
    li   x2, 10
    li   x11, 0

    bgt  x5, x2, IF1
    beq  x5, x2, IF2

    li   x11, 300
    j    END

IF1:
    li   x11, 100
    j    END

IF2:
    li   x11, 200
    j    END

END:
