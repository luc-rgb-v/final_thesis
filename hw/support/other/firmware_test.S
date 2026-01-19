# ============================================================
# ir_dc_only_4.S
# - Use 4 samples from pun_ir_buffer: 33897, 34126, 34653, 35203
# - Step 1: mean of IR[0..3]  (mean = sum >> 2)
# - Step 2: x[k] = mean - IR[k]  (store int32, 4 values)
# - No moving average stage
# ============================================================

.section .text
.globl _start
_start:
  # DMEM base (your working region)
  lui   x1, 0x80010          # x1 = 0x8001_0000

  # Layout in DMEM:
  #   IR base = x1 + 0x00   (4 * 2 = 8 bytes)
  #   X  base = x1 + 0x20   (4 * 4 = 16 bytes)  x[k] = mean - IR[k]
  addi  x2, x1, 0            # x2 = IR_ptr
  addi  x3, x1, 32           # x3 = X_ptr

  # ------------------------------------------------------------
  # Init 4 samples (from pun_ir_buffer[0..3])
  # 33897, 34126, 34653, 35203
  # ------------------------------------------------------------
  li   x4, 33897
  sh   x4, 0(x2)
  li   x4, 34126
  sh   x4, 2(x2)
  li   x4, 34653
  sh   x4, 4(x2)
  li   x4, 35203
  sh   x4, 6(x2)

  # ============================================================
  # Step 1: sum IR[0..3] -> x6
  # ============================================================
  li   x5, 0                 # k
  li   x6, 0                 # sum
  mv   x7, x2                # ptr = IR_ptr

sum_loop:
  li   x8, 4
  beq  x5, x8, sum_done
  lhu  x9, 0(x7)
  add  x6, x6, x9
  addi x7, x7, 2
  addi x5, x5, 1
  j    sum_loop

sum_done:
  # mean = sum / 4 => >> 2
  srli x11, x6, 2            # x11 = mean

  # ============================================================
  # Step 2: x[k] = mean - IR[k]  (store 4 int32 at X base)
  # ============================================================
  li   x5, 0
  mv   x7, x2                # IR read ptr
  mv   x13, x3               # X write ptr

dc_loop:
  li   x8, 4
  beq  x5, x8, dc_done
  lhu  x9, 0(x7)             # IR[k]
  sub  x14, x11, x9          # x[k] = mean - IR[k] (signed)
  sw   x14, 0(x13)           # store int32
  addi x7,  x7, 2
  addi x13, x13, 4
  addi x5,  x5, 1
  j    dc_loop

dc_done:
  nop
  nop
  nop
