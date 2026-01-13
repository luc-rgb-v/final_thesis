    .section .text
    .globl _start

_start:
    # Base address of array
    la x10, fib_array   # x10 = ptr

    # fib[0] = 0
    li x1, 0
    sw x1, 0(x10)

    # fib[1] = 1
    li x2, 1
    sw x2, 4(x10)

    # i = 2
    li x3, 2

    # N = 10
    li x4, 10

fib_loop:
    # load fib[i-1]
    addi x5, x3, -1
    slli x5, x5, 2
    add x5, x10, x5
    lw x6, 0(x5)

    # load fib[i-2]
    addi x7, x3, -2
    slli x7, x7, 2
    add x7, x10, x7
    lw x8, 0(x7)

    # fib[i] = fib[i-1] + fib[i-2]
    add x9, x6, x8

    # store fib[i]
    slli x11, x3, 2
    add x11, x10, x11
    sw x9, 0(x11)

    addi x3, x3, 1
    blt x3, x4, fib_loop

    # --------------------------------
    # Now compute sum of fib[0..9]
    # --------------------------------
    li x3, 0        # i = 0
    li x12, 0       # sum = 0

sum_loop:
    slli x5, x3, 2
    add x5, x10, x5
    lw x6, 0(x5)

    add x12, x12, x6

    addi x3, x3, 1
    blt x3, x4, sum_loop

end:
    ebreak

    .section .data
fib_array:
    .word 0,0,0,0,0,0,0,0,0,0
