.section .text
.globl _start
_start:

lui x1,0x40000        #x1=0x40000000

addi x2,x0,0xA5       #x2=0x000000A5
addi x3,x0,0x57       #x3=0x00000057
addi x4,x0,0x00       #x4=0x00000000
addi x5,x0,0x01       #x5=0x00000001

nop
nop
nop
nop

#I2C_WDATA   32'h40000000
#I2C_ADDR    32'h40000004
#I2C_RW      32'h40000008
#I2C_ENABLE  32'h4000000C

sw x2,0(x1)           #mem[0x40000000] I2C_WDATA =0x1F
sw x3,4(x1)           #mem[0x40000004] I2C_ADDR =0x57
sw x5,8(x1)           #mem[0x40000008] I2C_RW =0x00
sw x5,12(x1)          #mem[0x4000000C] I2C_ENABLE =0x01
#sw x4,12(x1)         #mem[0x4000000C] I2C_ENABLE =0x00
nop
nop
nop
nop
addi x10,x0,0x01

#sw x3,4(x1)           #mem[0x40000004]=0x55
#sw x5,8(x1)           #mem[0x40000008]=0x01
#sw x5,12(x1)          #mem[0x4000000C]=0x01

#lw x6,16(x1)          #x6=I2C_RDATA
