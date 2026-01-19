.section .text
.globl _start
_start:

#104 101 108 108 111
# h   e   l   l   o
lui x1,0xC0000

# li   x3, 10417
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
sw x2,0(x1)    # UART_DATA
sw x3,4(x1)    # UART_PRESCALE
sw x3,8(x1)    # UART_VALID
sw x0,8(x1)    # UART_VALID
addi x31,x31,1 #