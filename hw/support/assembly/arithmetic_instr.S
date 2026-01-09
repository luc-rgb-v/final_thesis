.section .text
.globl _start

_start:
    lui x1,0x12345
    auipc x2,0x00001
    addi x3,x0,10
    slli x4,x3,2
    slti x5,x3,20
    sltiu x6,x3,20
    xori x7,x3,0xF
    srli x8,x4,1
    srai x9,x4,1
    ori  x10,x3,0x20
    andi x11,x3,0x7

    add  x12,x3,x4
    sub  x13,x4,x3
    sll  x14,x3,x5
    slt  x15,x3,x4
    sltu x16,x3,x4
    xor  x17,x3,x4
    srl  x18,x4,x5
    sra  x19,x4,x5
    or   x20,x3,x4
    and  x21,x3,x4
