.section .text
.globl _start
_start:
  lui  x1,0x80010
  addi x31,x0,0

  lui  x2,0x11223
  addi x2,x2,0x344
  addi x3,x0,-1

  addi x13,x0,0x7f
  slli x13,x13,8
  ori  x13,x13,0xaa
  slli x13,x13,8
  ori  x13,x13,0x55
  slli x13,x13,8
  ori  x13,x13,0x11

  sw   x2,0(x1)
  sh   x2,4(x1)
  sb   x2,6(x1)
  sb   x3,8(x1)
  sh   x3,10(x1)
  sw   x13,12(x1)

  lw   x4,0(x1)
  lh   x5,4(x1)
  lhu  x6,4(x1)
  lb   x7,6(x1)
  lbu  x8,6(x1)
  lb   x9,8(x1)
  lbu  x10,8(x1)
  lh   x11,10(x1)
  lhu  x12,10(x1)

  addi x14,x1,64
  sw   x3,0(x14)
  lw   x15,0(x14)

  addi x16,x0,1
  slli x16,x16,31
  sw   x16,16(x1)
  lw   x17,16(x1)

  addi x18,x0,-128
  sb   x18,20(x1)
  lb   x19,20(x1)
  lbu  x20,20(x1)

  addi x21,x0,-1
  sh   x21,22(x1)
  lh   x22,22(x1)
  lhu  x23,22(x1)

  addi x24,x0,0x12
  slli x24,x24,8
  ori  x24,x24,0x34
  sh   x24,24(x1)
  lh   x25,24(x1)
  lhu  x26,24(x1)

  addi x27,x0,0x80
  sb   x27,26(x1)
  lb   x28,26(x1)
  lbu  x29,26(x1)

  addi x30,x0,0
  sw   x30,28(x1)
  lw   x30,28(x1)
  # ---- Misaligned access tests (will TRAP) ----
  sw   x2,1(x1)
  sw   x2,2(x1)
  sw   x2,3(x1)

  sh   x2,1(x1)
  sh   x2,3(x1)

  lw   x4,1(x1)
  lw   x4,2(x1)
  lw   x4,3(x1)
