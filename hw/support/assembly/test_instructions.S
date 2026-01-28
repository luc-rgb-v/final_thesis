.section .text
.globl _start

_start:
    lui  x10, 0x80001      # x10 = 0x80001000  (data base)

    li   x1, 0
    sw   x1, 0(x10)        # fib[0] = 0

    li   x2, 1
    sw   x2, 4(x10)        # fib[1] = 1

    li   x3, 2             # i = 2
    li   x4, 10            # N = 10
    li   x12, 1            # sum = 1

fib_loop:
    add  x6, x1, x2        # next = prev + curr

    slli x5, x3, 2
    add  x5, x10, x5
    sw   x6, 0(x5)         # store fib[i]

    add  x12, x12, x6

    mv   x1, x2
    mv   x2, x6

    addi x3, x3, 1
    blt  x3, x4, fib_loop

end:

