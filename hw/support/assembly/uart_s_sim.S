.section .text
.globl _start
_start:

#104 101 108 108 111
# h   e   l   l   o
lui x1,0xC0000
addi x3,x0,1
addi x2,x0,104
addi x5,x0,101
addi x6,x0,108
addi x7,x0,108
addi x8,x0,111
nop
nop
nop
nop
sw x2,0(x1)
sw x3,4(x1)
sw x3,8(x1)
sw x0,8(x1)
nop
nop
nop
nop
nop
nop
nop
sw x5,0(x1)
sw x3,4(x1)
sw x3,8(x1)
sw x0,8(x1)
nop
nop
nop
nop
nop
nop
nop
sw x6,0(x1)
sw x3,4(x1)
sw x3,8(x1)
sw x0,8(x1)
nop
nop
nop
nop
nop
nop
nop
sw x7,0(x1)
sw x3,4(x1)
sw x3,8(x1)
sw x0,8(x1)
nop
nop
nop
nop
nop
nop
nop
sw x8,0(x1)
sw x3,4(x1)
sw x3,8(x1)
sw x0,8(x1)
addi x9,x0,55
addi x10,x0,66
addi x11,x0,77
addi x12,x0,88
addi x3,x0,0
sw x3,2(x1)
