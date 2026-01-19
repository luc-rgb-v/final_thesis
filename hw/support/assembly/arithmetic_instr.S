.section .text
.globl _start

_start:
    lui  x1,0x12345
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

    addi x22,x0,-1
    addi x23,x0,-20

    add  x24,x3,x23
    sub  x25,x3,x23
    add  x26,x22,x3
    sub  x27,x3,x22

    slli x28,x3,31
    srli x29,x28,31
    srai x30,x28,31

    slt  x31,x23,x3
    sltu x5,x23,x3

    lui  x6,0xAAAAA
    ori  x6,x6,0x555

    and  x7,x6,x22
    xor  x8,x6,x22

    add  x9,x3,x4
    sub  x9,x9,x5
    slli x9,x9,1
    addi x9,x9,-8

    add  x10,x0,x0
    sub  x0,x3,x4

    addi x11,x0,5
    add  x12,x11,x11
    add  x13,x12,x11
    add  x14,x13,x12
    add  x15,x14,x13
