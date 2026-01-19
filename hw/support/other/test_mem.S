# ============================================================
# dmem_access_misaligned_end.S
# - Same aligned tests first (safe for all cores)
# - Misaligned tests moved to the END
#   -> if core/spike traps, only the last part is affected
# ============================================================

.section .text
.globl _start
_start:
  # -----------------------------
  # Base address
  # -----------------------------
  lui   x1, 0x80000          # x1 = 0x8000_0000
  addi  x31, x0, 0

  # x2 = 0x11223344
  lui   x2, 0x11223
  addi  x2, x2, 0x344

  # x3 = 0xFFFFFFFF (-1)
  addi  x3, x0, -1

  # x13 = 0x7FAA5511
  addi  x13, x0, 0x7f
  slli  x13, x13, 8
  ori   x13, x13, 0xaa
  slli  x13, x13, 8
  ori   x13, x13, 0x55
  slli  x13, x13, 8
  ori   x13, x13, 0x11

  # ============================================================
  # Part 1: ALIGNED stores (safe)
  # ============================================================
  sw    x2,  0(x1)           # [0..3]  = 44 33 22 11
  sh    x2,  4(x1)           # [4..5]  = 44 33
  sb    x2,  6(x1)           # [6]     = 44
  sb    x3,  8(x1)           # [8]     = FF
  sh    x3, 10(x1)           # [10..11]= FF FF
  sw    x13,12(x1)           # [12..15]= 11 55 AA 7F

  # ============================================================
  # Part 2: ALIGNED loads (safe)
  # ============================================================
  lw    x4,  0(x1)           # expect 0x11223344
  lh    x5,  4(x1)           # expect 0x00003344
  lhu   x6,  4(x1)           # expect 0x00003344
  lb    x7,  6(x1)           # expect 0x00000044
  lbu   x8,  6(x1)           # expect 0x00000044
  lb    x9,  8(x1)           # expect 0xFFFFFFFF
  lbu   x10, 8(x1)           # expect 0x000000FF
  lh    x11,10(x1)           # expect 0xFFFFFFFF
  lhu   x12,10(x1)           # expect 0x0000FFFF

  # ============================================================
  # Part 3: Extra aligned sign/zero-ext tests (safe)
  # ============================================================
  # store/load 0x80000000
  addi  x16, x0, 1
  slli  x16, x16, 31
  sw    x16,16(x1)
  lw    x17,16(x1)           # expect 0x80000000

  # store byte -128 (0x80) and read back
  addi  x18, x0, -128
  sb    x18,20(x1)
  lb    x19,20(x1)           # expect 0xFFFFFF80
  lbu   x20,20(x1)           # expect 0x00000080

  # store halfword -1 (0xFFFF)
  addi  x21, x0, -1
  sh    x21,22(x1)
  lh    x22,22(x1)           # expect 0xFFFFFFFF
  lhu   x23,22(x1)           # expect 0x0000FFFF

  # store halfword 0x1234
  addi  x24, x0, 0x12
  slli  x24, x24, 8
  ori   x24, x24, 0x34       # x24 = 0x1234
  sh    x24,24(x1)
  lh    x25,24(x1)           # expect 0x00001234
  lhu   x26,24(x1)           # expect 0x00001234

  # store byte 0x80
  addi  x27, x0, 0x80
  sb    x27,26(x1)
  lb    x28,26(x1)           # expect 0xFFFFFF80
  lbu   x29,26(x1)           # expect 0x00000080

  # ============================================================
  # Part 4: MISALIGNED tests moved to the END
  # If core/spike traps, it stops here only.
  # ============================================================

  # --- Misaligned SW (addr % 4 != 0) ---
  sw    x2,  1(x1)           # may trap
  sw    x2,  2(x1)           # may trap
  sw    x2,  3(x1)           # may trap

  # --- Misaligned SH (addr % 2 != 0) ---
  sh    x2,  1(x1)           # may trap
  sh    x2,  3(x1)           # may trap

  # --- Misaligned LW (addr % 4 != 0) ---
  lw    x14, 1(x1)           # may trap
  lw    x15, 2(x1)           # may trap
  lw    x16, 3(x1)           # may trap

  # done (no ecall; your tb will stop by cycle limit)
  nop
  nop
  nop
