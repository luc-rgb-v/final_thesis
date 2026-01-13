.section .text
.globl _start
_start:
  addi x31, x0, 0

  lui  x7, 0x80000
  addi x7, x7, 0
  addi x8, x7, 0x200

  addi x1, x0, 2047
  addi x2, x0, -2048
  addi x3, x0, -1

  addi x4, x1, -2047
  bne  x4, x0, fail_i

  andi x5, x3, 2047
  bne  x5, x1, fail_i

  andi x6, x3, -2048
  addi x9, x0, -2048
  bne  x6, x9, fail_i

  ori  x10, x0, -2048
  bne  x10, x9, fail_i

  xori x11, x0, -1
  bne  x11, x3, fail_i

  slti x12, x3, 0
  addi x13, x0, 1
  bne  x12, x13, fail_i

  slti x14, x3, -2048
  bne  x14, x0, fail_i

  sltiu x15, x3, 0
  bne  x15, x0, fail_i

  sltiu x16, x0, -1
  bne  x16, x13, fail_i

  j    ok_i
fail_i:
  ori  x31, x31, 1
ok_i:

  addi x12, x0, 1
  slli x13, x12, 31
  lui  x14, 0x80000
  bne  x13, x14, fail_s

  srli x15, x13, 31
  bne  x15, x12, fail_s

  srai x16, x13, 31
  bne  x16, x3, fail_s

  slli x17, x12, 0
  bne  x17, x12, fail_s

  j    ok_s
fail_s:
  ori  x31, x31, 2
ok_s:

  sw   x1, 0(x8)
  sw   x2, 4(x8)
  sw   x3, 2044(x8)

  lw   x18, 0(x8)
  bne  x18, x1, fail_m

  lw   x19, 4(x8)
  bne  x19, x2, fail_m

  lw   x20, 2044(x8)
  bne  x20, x3, fail_m

  addi x21, x8, 16
  lw   x22, -16(x21)
  bne  x22, x1, fail_m

  lw   x23, -12(x21)
  bne  x23, x2, fail_m

  addi x24, x0, 9
  sw   x24, -8(x21)
  lw   x25, 8(x8)
  bne  x25, x24, fail_m

  j    ok_m
fail_m:
  ori  x31, x31, 4
ok_m:

  addi x26, x0, 5
  addi x27, x0, 0
loop_b:
  addi x27, x27, 1
  addi x26, x26, -1
  bne  x26, x0, loop_b

  addi x28, x0, 5
  bne  x27, x28, fail_b
  beq  x0, x0, ok_b
fail_b:
  ori  x31, x31, 8
ok_b:

  auipc x2, 0
  auipc x3, 1
  addi  x2, x2, 4
  sub   x4, x3, x2
  lui   x5, 0x1
  bne   x4, x5, fail_u
  j     ok_u
fail_u:
  ori   x31, x31, 64
ok_u:

  auipc x28, 0
  jal   x6, jal_tgt
  ori   x31, x31, 16
jal_tgt:
  addi  x29, x28, 8
  bne   x6, x29, fail_j
  j     ok_j
fail_j:
  ori   x31, x31, 16
ok_j:

  auipc x30, 0
  addi  x30, x30, 32
  jalr  x6, x30, 0
  ori   x31, x31, 32
  addi  x0,  x0,  0
  addi  x0,  x0,  0
  addi  x0,  x0,  0
  addi  x0,  x0,  0
jalr_tgt:
  addi  x29, x30, -20
  bne   x6,  x29, fail_r
  j     ok_r
fail_r:
  ori   x31, x31, 32
ok_r:

  sw   x31, 0(x7)

done:
  j done
