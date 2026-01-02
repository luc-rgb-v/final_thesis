.section .text
.globl _start

_start:
    la   sp, _stack_top   # init stack
    call main             # jump to C++ main()

1:
    j 1b                  # halt here if main returns
