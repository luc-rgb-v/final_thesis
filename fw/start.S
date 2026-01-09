.section .text._start
.globl _start
_start:
    /* setup stack */
    la sp, _stack_top

    /* clear .bss */
    la t0, _bss_start
    la t1, _bss_end
1:
    bge t0, t1, 2f
    sw zero, 0(t0)
    addi t0, t0, 4
    j 1b
2:
    /* call main */
    call main

3:  j 3b
