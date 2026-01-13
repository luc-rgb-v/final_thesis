.section .text
.globl _start
_start:

lui x1, 0x80000
addi  x2,  x0,  55
addi  x3,  x0,  56
addi  x4,  x0,  57
addi  x5,  x0,  58
addi  x6,  x0,  59
addi  x7,  x0,  60
addi  x8,  x0,  61
nop
nop
nop
nop
nop
sw x2,0(x1)
sw x3,4(x1)
sw x4,8(x1)
sw x5,12(x1)

lw x11, 0(x1)
#lw x12, 4(x1)
#lw x13, 8(x1)
#lw x14, 12(x1)
nop
nop
nop
nop
nop
nop

