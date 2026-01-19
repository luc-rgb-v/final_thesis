.section .text
.globl _start
_start:
  lui  sp,0x80001
  lui  s0,0xC0000
  lui  s2,0x80000
  add  s3,s2,x0
  addi s1,x0,1

  lw   t0,0(s0)
  sw   t0,0(s3)
  lw   t1,4(s0)
  sw   t1,4(s3)
  lw   t2,8(s0)
  sw   t2,8(s3)
  lw   t3,12(s0)
  sw   t3,12(s3)
  addi s3,s3,16

  addi a0,x0,1
  jal  ra,set_prescale
  addi a0,x0,2
  jal  ra,set_prescale
  addi a0,x0,4
  jal  ra,set_prescale
  addi a0,x0,8
  jal  ra,set_prescale
  addi a0,x0,16
  jal  ra,set_prescale
  addi a0,x0,64
  jal  ra,set_prescale

  addi a0,x0,1
  slli a0,a0,8
  jal  ra,set_prescale

  addi a0,x0,0x12
  slli a0,a0,8
  ori  a0,a0,0x34
  jal  ra,set_prescale

  addi t0,x0,0
  sb   t0,0(s0)
  sb   t0,1(s0)
  sh   t0,2(s0)
  sh   t0,6(s0)
  sw   t0,8(s0)
  sw   t0,4(s0)

  lb   t1,0(s0)
  lbu  t2,1(s0)
  lh   t3,2(s0)
  lhu  t4,6(s0)
  lw   t5,4(s0)
  lw   t6,8(s0)
  sw   t1,0(s3)
  sw   t2,4(s3)
  sw   t3,8(s3)
  sw   t4,12(s3)
  sw   t5,16(s3)
  sw   t6,20(s3)
  addi s3,s3,24

  addi a0,x0,0x48
  jal  ra,putc
  addi a0,x0,0x65
  jal  ra,putc
  addi a0,x0,0x6c
  jal  ra,putc
  addi a0,x0,0x6c
  jal  ra,putc
  addi a0,x0,0x6f
  jal  ra,putc
  addi a0,x0,10
  jal  ra,putc

  addi a0,x0,16
  jal  ra,set_prescale
  addi t0,x0,0
1:
  add  a0,t0,x0
  jal  ra,putc
  addi t0,t0,1
  addi t1,x0,16
  blt  t0,t1,1b

  addi a0,x0,10
  jal  ra,putc

  addi a0,x0,64
  jal  ra,set_prescale
  addi t0,x0,0
  addi t2,x0,0x55
2:
  add  a0,t2,x0
  jal  ra,putc
  xori t2,t2,0xff
  addi t0,t0,1
  addi t1,x0,16
  blt  t0,t1,2b

  addi a0,x0,10
  jal  ra,putc

  addi a0,x0,1
  slli a0,a0,8
  jal  ra,set_prescale

  addi t0,x0,0
3:
  jal  ra,getc_sample
  addi t0,t0,1
  addi t1,x0,8
  blt  t0,t1,3b

  lw   t0,16(s0)
  sw   t0,0(s3)
  lw   t1,20(s0)
  sw   t1,4(s3)
  lw   t2,24(s0)
  sw   t2,8(s3)
  lw   t3,28(s0)
  sw   t3,12(s3)
  addi s3,s3,16

  addi t4,x0,0x7f
  addi t5,t4,1
  addi t6,x0,-1
  andi t6,t6,0xff
  sb   t4,0(s0)
  sb   t5,0(s0)
  sb   t6,0(s0)
  lb   t0,0(s0)
  lbu  t1,0(s0)
  sw   t0,0(s3)
  sw   t1,4(s3)
  addi s3,s3,8

  addi t0,s0,3
  lw   t1,0(t0)
  sw   t1,0(s3)
  addi s3,s3,4

  addi t0,s0,2
  sw   x0,0(t0)

  addi t0,x0,1
  lw   t1,0(t0)
  sw   t1,0(s3)
  addi s3,s3,4

4:
  jal  x0,4b

set_prescale:
  addi sp,sp,-16
  sw   ra,12(sp)
  sw   a0,8(sp)
  sw   a1,4(sp)
  sw   a2,0(sp)

  sw   a0,4(s0)
  lw   t0,4(s0)
  sw   t0,0(s3)
  lw   t1,12(s0)
  sw   t1,4(s3)
  addi s3,s3,8

  lw   ra,12(sp)
  lw   a0,8(sp)
  lw   a1,4(sp)
  lw   a2,0(sp)
  addi sp,sp,16
  jalr x0,0(ra)

putc:
  addi sp,sp,-16
  sw   ra,12(sp)
  sw   a0,8(sp)
  sw   t0,4(sp)
  sw   t1,0(sp)

  sw   a0,0(s0)
  sw   s1,8(s0)
  sw   x0,8(s0)

  addi t0,x0,2000
5:
  lw   t1,12(s0)
  andi t1,t1,1
  bne  t1,x0,6f
  addi t0,t0,-1
  bne  t0,x0,5b
6:
  lw   t0,0(s0)
  sw   t0,0(s3)
  lw   t0,4(s0)
  sw   t0,4(s3)
  lw   t0,8(s0)
  sw   t0,8(s3)
  lw   t0,12(s0)
  sw   t0,12(s3)
  addi s3,s3,16

  lw   ra,12(sp)
  lw   a0,8(sp)
  lw   t0,4(sp)
  lw   t1,0(sp)
  addi sp,sp,16
  jalr x0,0(ra)

getc_sample:
  addi sp,sp,-16
  sw   ra,12(sp)
  sw   t0,8(sp)
  sw   t1,4(sp)
  sw   t2,0(sp)

  lw   t0,0(s0)
  lw   t1,8(s0)
  lw   t2,12(s0)
  sw   t0,0(s3)
  sw   t1,4(s3)
  sw   t2,8(s3)
  addi s3,s3,12

  addi t0,x0,400
7:
  addi t0,t0,-1
  bne  t0,x0,7b

  lw   ra,12(sp)
  lw   t0,8(sp)
  lw   t1,4(sp)
  lw   t2,0(sp)
  addi sp,sp,16
  jalr x0,0(ra)
