.section .text.boot
.globl _start
_start:
    la  sp, _stack_pointer     # initialize stack
    call main                  # jump to C main()
1:  j   1b                     # infinite loop after main returns
