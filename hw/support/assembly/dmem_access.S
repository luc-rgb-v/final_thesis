.section .text
.globl _start
_start:
lui x1,0x80000        #x1=0x80000000
lui x2,0x11223        #x2=0x11223000
addi x2,x2,0x344      #x2=0x11223344
addi x3,x0,-1         #x3=0xFFFFFFFF
nop
nop

sw x2,0(x1)           #mem[0x80000000]=0x11223344
sh x2,4(x1)           #mem[0x80000004]=0x3344
sb x2,6(x1)           #mem[0x80000006]=0x44
sb x3,8(x1)           #mem[0x80000008]=0xFF
sh x3,10(x1)          #mem[0x8000000A]=0xFFFF
nop
nop
nop

lw x4,0(x1)           #x4=0x11223344
lh x5,4(x1)           #x5=0x00003344
lhu x6,4(x1)          #x6=0x00003344
lb x7,6(x1)           #x7=0x00000044
lbu x8,6(x1)          #x8=0x00000044
lb x9,8(x1)           #x9=0xFFFFFFFF
lbu x10,8(x1)         #x10=0x000000FF
lh x11,10(x1)         #x11=0xFFFFFFFF
lhu x12,10(x1)        #x12=0x0000FFFF
lhu x0,10(x1)        #x12=0x0000FFFF

