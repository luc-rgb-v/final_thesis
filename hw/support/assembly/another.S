.section .text
.globl _start
_start:
  addi x31, x0, 0

  lui  x7, 0x80000
  addi x7, x7, 0
  addi x9, x7, 0

  lui  x8, 0x80000
  addi x8, x8, 0x200

  lui  x1, 0x12345
  sw   x1, 0(x9)
  addi x9, x9, 4

  auipc x2, 0
  auipc x3, 1
  sub  x4, x3, x2
  lui  x5, 0x1
  bne  x4, x5, auipc_bad
  j    auipc_ok
auipc_bad:
  ori  x31, x31, 0x40
auipc_ok:
  sw   x4, 0(x9)
  addi x9, x9, 4

  addi x1, x0, 2047
  addi x2, x0, -2048
  addi x3, x0, -1
  add  x6, x1, x2
  bne  x6, x3, iimm_bad
  addi x4, x0, -1366
  addi x6, x4, 1366
  bne  x6, x0, iimm_bad
  andi x5, x3, 2047
  bne  x5, x1, iimm_bad
  ori  x5, x0, -1
  bne  x5, x3, iimm_bad
  xori x5, x0, -1
  bne  x5, x3, iimm_bad
  j    iimm_ok
iimm_bad:
  ori  x31, x31, 0x01
iimm_ok:
  sw   x1, 0(x9)
  addi x9, x9, 4
  sw   x2, 0(x9)
  addi x9, x9, 4
  sw   x3, 0(x9)
  addi x9, x9, 4
  sw   x4, 0(x9)
  addi x9, x9, 4

  addi x5, x0, 1
  slli x6, x5, 31
  lui  x10, 0x80000
  bne  x6, x10, sh_bad
  srli x11, x6, 31
  addi x12, x0, 1
  bne  x11, x12, sh_bad
  srai x13, x6, 31
  addi x14, x0, -1
  bne  x13, x14, sh_bad
  slli x15, x5, 0
  bne  x15, x5, sh_bad
  j    sh_ok
sh_bad:
  ori  x31, x31, 0x02
sh_ok:
  sw   x6, 0(x9)
  addi x9, x9, 4
  sw   x11, 0(x9)
  addi x9, x9, 4
  sw   x13, 0(x9)
  addi x9, x9, 4

  addi x1, x0, 7
  sw   x1, 0(x8)
  addi x1, x0, -1
  sw   x1, 4(x8)
  addi x1, x0, -2048
  sw   x1, 8(x8)
  addi x1, x0, 2047
  sw   x1, 12(x8)

  addi x5, x0, 85
  sw   x5, 2044(x8)
  lw   x6, 2044(x8)
  bne  x6, x5, mem_bad

  lw   x2, 0(x8)
  addi x3, x0, 7
  bne  x2, x3, mem_bad

  lw   x2, 4(x8)
  addi x3, x0, -1
  bne  x2, x3, mem_bad

  lw   x2, 8(x8)
  addi x3, x0, -2048
  bne  x2, x3, mem_bad

  lw   x2, 12(x8)
  addi x3, x0, 2047
  bne  x2, x3, mem_bad

  addi x6, x8, 16
  lw   x10, -16(x6)
  addi x11, x0, 7
  bne  x10, x11, mem_bad

  lw   x10, -12(x6)
  addi x11, x0, -1
  bne  x10, x11, mem_bad

  addi x12, x0, 9
  sw   x12, -8(x6)
  lw   x13, 8(x8)
  bne  x13, x12, mem_bad

  j    mem_ok
mem_bad:
  ori  x31, x31, 0x04
mem_ok:
  sw   x31, 0(x9)
  addi x9, x9, 4

  addi x14, x0, 0
  beq  x0, x0, b_fwd16
  addi x14, x14, 1
  addi x14, x14, 2
  addi x14, x14, 4
b_fwd16:
  addi x14, x14, 8
  addi x15, x0, 8
  bne  x14, x15, bsmall_bad
  j    bsmall_ok
bsmall_bad:
  ori  x31, x31, 0x08
bsmall_ok:
  sw   x14, 0(x9)
  addi x9, x9, 4

  addi x15, x0, 3
  addi x16, x0, 0
b_loop_m20:
  addi x16, x16, 1
  addi x15, x15, -1
  addi x0,  x0,  0
  addi x0,  x0,  0
  addi x0,  x0,  0
  addi x0,  x0,  0
  addi x0,  x0,  0
  addi x0,  x0,  0
  bne  x15, x0, b_loop_m20

  addi x17, x0, 3
  bne  x16, x17, bneg_bad
  j    bneg_ok
bneg_bad:
  ori  x31, x31, 0x08
bneg_ok:
  sw   x16, 0(x9)
  addi x9, x9, 4

  addi x18, x0, 0
  beq  x0, x0, b_far_p800
  addi x18, x0, 1
  ori  x31, x31, 0x10
  .rept 511
    addi x0, x0, 0
  .endr
b_far_p800:
  addi x18, x0, 2
  addi x19, x0, 2
  bne  x18, x19, bfar_bad
  j    bfar_ok
bfar_bad:
  ori  x31, x31, 0x10
bfar_ok:
  sw   x18, 0(x9)
  addi x9, x9, 4

  auipc x20, 0
  jal   x1, j_far_p800
  ori   x31, x31, 0x20
  .rept 511
    addi x0, x0, 0
  .endr
j_far_p800:
  addi x21, x20, 8
  bne  x1, x21, jal_bad
  j    jal_ok
jal_bad:
  ori  x31, x31, 0x20
jal_ok:
  sw   x1, 0(x9)
  addi x9, x9, 4

  auipc x22, 0
  jalr  x23, x22, 16
  ori   x31, x31, 0x80
  addi  x0, x0, 0
  addi  x0, x0, 0
jalr_tgt:
  addi x24, x22, 8
  bne  x23, x24, jalr_bad
  j    jalr_ok
jalr_bad:
  ori  x31, x31, 0x80
jalr_ok:
  sw   x23, 0(x9)
  addi x9, x9, 4

  sw   x31, 0(x9)
  addi x9, x9, 4

done:
  j done
