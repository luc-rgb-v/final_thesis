.section .text
.globl _start
_start:

lui x1,0x40000

addi x2,x0,0x57

addi x3,x0,0x77  # w
addi x4,x0,0x6F  # o
addi x5,x0,0x72  # r
addi x6,x0,0x6C  # l
addi x7,x0,0x64  # d

addi x30,x0,0x1

sw x2,4(x1)           #I2C_ADDR
sw x0,8(x1)           #I2C_RW

sw x3,0(x1)           #I2C_WDATA
sw x30,12(x1)         #I2C_ENABLE
sw x0,12(x1)          #I2C_ENABLE

WAIT_LOOP:
    lw   x29, 20(x1)
    beq  x29, x0, WAIT_LOOP

sw x4,0(x1)           #I2C_WDATA
sw x30,12(x1)         #I2C_ENABLE
sw x0,12(x1)          #I2C_ENABLE

WAIT_LOOP_1:
    lw   x29, 20(x1)
    beq  x29, x0, WAIT_LOOP_1

sw x5,0(x1)           #I2C_WDATA
sw x30,12(x1)         #I2C_ENABLE
sw x0,12(x1)          #I2C_ENABLE

WAIT_LOOP_2:
    lw   x29, 20(x1)
    beq  x29, x0, WAIT_LOOP_2

sw x6,0(x1)           #I2C_WDATA
sw x30,12(x1)         #I2C_ENABLE
sw x0,12(x1)          #I2C_ENABLE

WAIT_LOOP_3:
    lw   x29, 20(x1)
    beq  x29, x0, WAIT_LOOP_3

sw x7,0(x1)           #I2C_WDATA
sw x30,12(x1)         #I2C_ENABLE
sw x0,12(x1)          #I2C_ENABLE

WAIT_LOOP_4:
    lw   x29, 20(x1)
    beq  x29, x0, WAIT_LOOP_4

sw x30,8(x1)          #I2C_RW
sw x30,12(x1)         #I2C_ENABLE
sw x0,12(x1)          #I2C_ENABLE

WAIT_LOOP_5:
    lw   x29, 20(x1)
    beq  x29, x0, WAIT_LOOP_5

lw x8,16(x1)          #x6=I2C_RDATA
sw x30,8(x1)          #I2C_RW

addi x31,x31,0x1
