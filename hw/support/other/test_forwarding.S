.section .text
.globl _start

_start:

    # Base seed
    li x1, 1          # x1 = 1

    # ------------------------------------------------
    # Build chain with maximum RAW hazards
    # Each instruction consumes the previous result
    # ------------------------------------------------

    add  x2,  x1,  x1     # 2
    add  x3,  x2,  x1     # 3
    add  x4,  x3,  x1     # 4
    add  x5,  x4,  x1     # 5
    add  x6,  x5,  x1     # 6
    add  x7,  x6,  x1     # 7
    add  x8,  x7,  x1     # 8
    add  x9,  x8,  x1     # 9
    add  x10, x9,  x1     # 10
    add  x11, x10, x1     # 11
    add  x12, x11, x1     # 12
    add  x13, x12, x1     # 13
    add  x14, x13, x1     # 14
    add  x15, x14, x1     # 15
    add  x16, x15, x1     # 16
    add  x17, x16, x1     # 17
    add  x18, x17, x1     # 18
    add  x19, x18, x1     # 19
    add  x20, x19, x1     # 20
    add  x21, x20, x1     # 21
    add  x22, x21, x1     # 22
    add  x23, x22, x1     # 23
    add  x24, x23, x1     # 24
    add  x25, x24, x1     # 25
    add  x26, x25, x1     # 26
    add  x27, x26, x1     # 27
    add  x28, x27, x1     # 28
    add  x29, x28, x1     # 29
    add  x30, x29, x1     # 30
    add  x31, x30, x1     # 31

    # ------------------------------------------------
    # Backward dependency hazards
    # These must NOT corrupt results
    # ------------------------------------------------
    add x5,  x31, x0      # x5 = 31
    sub x5,  x5,  x26     # 31 - 26 = 5   (RAW hazard)
    add x6,  x5,  x1     # 5 + 1 = 6      (must restore x6)
    add x7,  x6,  x1     # 7
    add x8,  x7,  x1     # 8

    # Re-inject correct chain end
    add x9,  x8,  x1     # 9
    add x10, x9,  x1     # 10

    # Repair full chain using live data
    add x11, x10, x1     # 11
    add x12, x11, x1
    add x13, x12, x1
    add x14, x13, x1
    add x15, x14, x1
    add x16, x15, x1
    add x17, x16, x1
    add x18, x17, x1
    add x19, x18, x1
    add x20, x19, x1
    add x21, x20, x1
    add x22, x21, x1
    add x23, x22, x1
    add x24, x23, x1
    add x25, x24, x1
    add x26, x25, x1
    add x27, x26, x1
    add x28, x27, x1
    add x29, x28, x1
    add x30, x29, x1
    add x31, x30, x1

end:
    nop
