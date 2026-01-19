.section .text
.globl _start

_start:
    li x1, 200        # x1 = N = 99
    li x2, 0         # x2 = sum = 0
    li x3, 1         # x3 = i = 1

loop:
    add  x2, x2, x3   # sum += i
    addi x3, x3, 1    # i++
    ble  x3, x1, loop # if (i <= 99) loop

end:
    nop
