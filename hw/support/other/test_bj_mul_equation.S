#int A = 7;
#int B = 5;
#int C = 3;
#int result = mul(add(A,B), C);

.section .text
.globl _start

_start:

    # ----------------------------------
    # Load constants using LUI
    # ----------------------------------
    lui  x11, 0          # A
    addi x11, x11, 7     # A = 7

    lui  x12, 0          # B
    addi x12, x12, 5     # B = 5

    lui  x13, 0          # C
    addi x13, x13, 3     # C = 3

    # ----------------------------------
    # Call add(A,B)
    # ----------------------------------
    auipc x20, 0
    addi  x20, x20, add_func - .

    jalr x1, x20, 0       # x10 = add(x11, x12)

    # ----------------------------------
    # Call mul(sum, C)
    # ----------------------------------
    auipc x20, 0
    addi  x20, x20, mul_func - .

    jalr x1, x20, 0       # x10 = mul(x10, x13)

    jal x0, end

# ==========================================
# add_func(a,b)
# returns x10 = a+b
# ==========================================
add_func:
    add x10, x11, x12
    jalr x0, x1, 0

# ==========================================
# mul_func(x,y)
# x10 = x * y (by repeated add)
# ==========================================
mul_func:
    addi x14, x0, 0     # acc = 0
    addi x15, x0, 0     # i = 0

mul_loop:
    beq  x15, x13, mul_done
    add  x14, x14, x10
    addi x15, x15, 1
    jal  x0, mul_loop

mul_done:
    add x10, x14, x0
    jalr x0, x1, 0


end:
    nop
