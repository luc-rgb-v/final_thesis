_start:
    li      t0, 10              # Counter starts at 10
    li      t1, 0               # Test value for branch comparisons
    li      t2, 5               # Another value for signed/unsigned branch tests

main_loop:
    beq t0, x0, done            # Branch if equal to zero (beq t0, x0)
    addi    t0, t0, -1          # Decrement counter

    jal     ra, subroutine_a    # Save PC+4 in ra, jump to subroutine_a

    la      t3, subroutine_b    # Load address of subroutine_b into t3
    jalr    ra, t3, 0           # Jump to t3 + 0, save PC+4 in ra

    beq     t0, t1, skip_a      # branch if t0 == t1 (should not branch)
    bne     t0, t1, skip_a      # branch if t0 != t1 (should branch)
    nop                         # filler
skip_a:
    blt     t0, t2, skip_b      # branch if t0 < t2 (signed)
    bge     t0, t2, skip_b      # branch if t0 >= t2 (signed)
    nop
skip_b:
    bltu    t0, t2, skip_c      # branch if t0 < t2 (unsigned)
    bgeu    t0, t2, skip_c      # branch if t0 >= t2 (unsigned)
    nop
skip_c:

    j       continue

continue:
    # 5. Test jr (jump register, pseudo for jalr x0, rs, 0)
    la      t3, main_loop       # load address of main_loop
    jr      t3                  # jump to t3 (back to loop)

    j       error               # error path

subroutine_a:
    addi    t4, t0, 0           # copy t0 to t4 (just to show work)
    ret                         # return: jalr x0, ra, 0

subroutine_b:
    addi    t4, t4, 1           # increment t4 (dummy work)
    jalr    x0, ra, 0           # explicit return (same as ret)

done:
    j       done

error:
    j       error               # should never reach here

# --------------------------------------------------
# Base address for data memory
# --------------------------------------------------
lui   x30, 0x00010        # x30 = 0x00010000 (DATA BASE)

lui   x20, 0x12345

addi  x1,  x0,  1

sw x1,   0(x30)
sw x2,   4(x30)

sh x4,   68(x30)          # half-word aligned
sb x5,   70(x30)

lw  x12,  0(x30)
lh  x13, 68(x30)
lhu x14, 68(x30)
lb  x15, 70(x30)
lbu x16, 70(x30)

add  x17, x1, x2
sub  x18, x3, x4
sll  x19, x5, x6
srl  x20, x5, x6
sra  x21, x5, x6

slt  x22, x5, x6
sltu x23, x5, x6
xor  x24, x5, x6
or   x25, x5, x6
and  x26, x5, x6

addi x5,  x6, 10
andi x6,  x7, 0xFF
ori  x7,  x8, 0x300
xori x8,  x9, 0x55

slti  x9,  x10, -8
sltiu x10, x11, 255
slli  x11, x12, 3
srli  x12, x13, 1
srai  x13, x14, 2

beq  x1, x1, label_ok
nop

label_ok:
bne  x1, x2, label_next
nop

label_next:
blt  x1, x2, label_jump
nop

label_jump:
jal  x1, label_end

nop
jalr x0, 0(x1)

label_end:
nop
