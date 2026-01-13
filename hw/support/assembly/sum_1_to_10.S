    .section .text
    .globl _start

_start:
    li x1, 10        # x1 = N = 10
    li x2, 0         # x2 = sum = 0
    li x3, 1         # x3 = i = 1
    li x5, 100       # fill x5
    li x11, 200      # fill x11

loop:
    add x2, x2, x3  # sum += i
    addi x3, x3, 1 # i++
    blt x3, x1, loop
    add x2, x2, x3  # add last value (10)

end:
    nop
