.section .text
.globl _start

_start:
    # -------------------------------------------------
    # Base address = 0x80000000
    # -------------------------------------------------
    lui  x10, 0x80000

    # -------------------------------------------------
    # Initialize array in memory
    # a = [7,3,9,1,4,8,2,5]
    # -------------------------------------------------
    addi x1, x0, 7
    sw   x1, 0(x10)
    addi x1, x0, 3
    sw   x1, 4(x10)
    addi x1, x0, 9
    sw   x1, 8(x10)
    addi x1, x0, 1
    sw   x1, 12(x10)
    addi x1, x0, 4
    sw   x1, 16(x10)
    addi x1, x0, 8
    sw   x1, 20(x10)
    addi x1, x0, 2
    sw   x1, 24(x10)
    addi x1, x0, 5
    sw   x1, 28(x10)

    # -------------------------------------------------
    # Setup
    # -------------------------------------------------
    addi x11, x0, 8       # N = 8
    addi x12, x0, 0       # i = 0

# =====================================================
# Outer loop
# =====================================================
outer_loop:
    addi x13, x0, 0       # j = 0

    addi x19, x11, -1     # limit = N-1
    sub  x19, x19, x12    # limit = N-1-i

# =====================================================
# Inner loop
# =====================================================
inner_loop:
    # ---- load a[j] ----
    slli x14, x13, 2
    add  x15, x10, x14
    lw   x16, 0(x15)
    nop
    nop
    nop

    # ---- load a[j+1] ----
    addi x14, x14, 4
    add  x17, x10, x14
    lw   x18, 0(x17)
    nop
    nop
    nop

    # ---- compare ----
    blt  x16, x18, no_swap
    nop
    nop

    # ---- swap ----
    sw   x18, 0(x15)
    sw   x16, 0(x17)

no_swap:
    addi x13, x13, 1
    nop
    nop

    blt  x13, x19, inner_loop
    nop
    nop

    # ---- next outer ----
    addi x12, x12, 1
    nop
    nop

    blt  x12, x11, outer_loop
    nop
    nop

# =====================================================
# Get max value (last element)
# =====================================================
    addi x20, x11, -1
    slli x20, x20, 2
    add  x20, x10, x20

    lw   x21, 0(x20)
    nop
    nop
    nop

# =====================================================
# End: do nothing
# =====================================================
end:
    addi x0, x0, 0
