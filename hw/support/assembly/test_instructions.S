.section .text
.globl _start

_start:
    # Test value
    li x10, 123        # dividend = 123

    jal x1, divu10_nomul

    # After return:
    # x12 = quotient (expected 12)
    # x13 = remainder (expected 3)

    j END


# --------------------------------
# divu10_nomul
# unsigned divide by 10
# RV32I only (no mul, no div)
# --------------------------------
# x10 = dividend
# x12 = quotient
# x13 = remainder
# 123 : 10 = 12 remain 3
# --------------------------------
divu10_nomul:

    # ---- compute x * 205 ----
    slli x5, x10, 7     # x * 128
    slli x6, x10, 6     # x * 64
    add  x5, x5, x6

    slli x6, x10, 3     # x * 8
    add  x5, x5, x6

    slli x6, x10, 2     # x * 4
    add  x5, x5, x6

    add  x5, x5, x10    # + x * 1
    # x5 = x * 205

    # ---- approximate quotient ----
    srli x12, x5, 11    # q ≈ x / 10

    # ---- compute q * 10 ----
    slli x6, x12, 3     # q * 8
    slli x7, x12, 1     # q * 2
    add  x6, x6, x7     # q * 10

    # ---- correction step ----
    bltu x6, x10, OK
    beq  x6, x10, OK
    addi x12, x12, -1   # q--

OK:
    # ---- remainder ----
    slli x6, x12, 3     # q * 8
    slli x7, x12, 1     # q * 2
    add  x6, x6, x7     # q * 10
    sub  x13, x10, x6   # r = x - q*10

    jalr x0, 0(x1)


# --------------------------------
# Program end (NOP loop)
# --------------------------------
END:
    nop
