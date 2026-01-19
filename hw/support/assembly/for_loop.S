.section .text
.globl _start

_start:
    li x1, 1      # i = 1
    li x2, 10     # limit = 10
    li x3, 0      # sum = 0

for_loop:
    bgt x1, x2, end_loop   # if (i > 10) break
    add x3, x3, x1        # sum = sum + i
    addi x1, x1, 1        # i++
    j for_loop            # repeat

end_loop:
    # result is now in x3 (sum = 55)
