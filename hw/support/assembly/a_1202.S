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


.section .text
.globl _start

_start:
    li   x31, 0

    li   x1, 7
    li   x2, 8
    add  x3, x1, x2
    addi x4, x3, 1
    li   x5, 16
    bne  x4, x5, t1_fail

    sub  x6, x1, x1
    beq  x6, x0, t3
t2_fail:
    ori  x31, x31, 0x02
    j    t3

t1_fail:
    ori  x31, x31, 0x01
    sub  x6, x1, x1
    bne  x6, x0, t2_fail
    j    t3

t3:
    lui  x7, 0x80000
    addi x7, x7, 0

    li   x9, 0x1234
    sw   x9, 0(x7)
    lw   x8, 0(x7)
    addi x10, x8, 1
    li   x11, 0x1235
    bne  x10, x11, t3_fail

    li   x12, 0x00AA
    addi x12, x12, 0x0055
    sw   x12, 4(x7)
    lw   x13, 4(x7)
    li   x14, 0x00FF
    bne  x13, x14, t4_fail

    li   x15, 1
    li   x16, 2
    add  x17, x15, x16
    nop
    nop
    nop
    beq  x17, x0, t5_fail
    j    done

t3_fail:
    ori  x31, x31, 0x04
    j    t4

t4_fail:
    ori  x31, x31, 0x08
    j    t5

t5_fail:
    ori  x31, x31, 0x10
    j    done

t4:
    li   x12, 0x00AA
    addi x12, x12, 0x0055
    sw   x12, 4(x7)
    lw   x13, 4(x7)
    li   x14, 0x00FF
    bne  x13, x14, t4_fail

t5:
    li   x15, 1
    li   x16, 2
    add  x17, x15, x16
    nop
    nop
    nop
    beq  x17, x0, t5_fail

done:
    ebreak


.section .text
.globl _start

_start:
    li   x5,  0x80000000
    li   x11, 0x00001020

    li   x31, 0

    lui  x7, 0x80000
    addi x7, x7, 0

    li   x9, 0xff
    sw   x9, 0(x7)
    lw   x13, 0(x7)
    addi x20, x13, 40

    li   x14, 0xff
    bne  x13, x14, fail

    li   x31, 0
    j    end

fail:
    li   x31, 1
    j    end

end:








.section .text
.globl _start

_start:
    li   x31, 0

    lui  x7, 0x80000
    addi x7, x7, 0

    lui  x2, 0x80001
    addi x2, x2, 0

    addi x8, x7, 0x100
    addi x10, x8, 0
    li   x11, 16
    jal  x1, fill_array

    addi x10, x8, 0
    li   x11, 16
    la   x6, compute_stats
    jalr x1, x6, 0

    li   x20, 136
    bne  x10, x20, sum_bad

    li   x21, 16
    bne  x11, x21, xor_bad

    li   x22, 16
    bne  x12, x22, max_bad

    j    write_out

sum_bad:
    ori  x31, x31, 0x01
    li   x21, 16
    bne  x11, x21, xor_bad2
    li   x22, 16
    bne  x12, x22, max_bad2
    j    write_out

xor_bad:
    ori  x31, x31, 0x02
    li   x22, 16
    bne  x12, x22, max_bad2
    j    write_out

max_bad:
    ori  x31, x31, 0x04
    j    write_out

xor_bad2:
    ori  x31, x31, 0x02
    li   x22, 16
    bne  x12, x22, max_bad2
    j    write_out

max_bad2:
    ori  x31, x31, 0x04

write_out:
    sw   x10, 0(x7)
    sw   x11, 4(x7)
    sw   x12, 8(x7)
    sw   x31, 12(x7)

end:
    jal  x0, end


fill_array:
    addi x5, x0, 1
    addi x6, x11, 0
    addi x28, x10, 0
fa_loop:
    sw   x5, 0(x28)
    addi x28, x28, 4
    addi x5, x5, 1
    addi x6, x6, -1
    bne  x6, x0, fa_loop
    jalr x0, x1, 0


compute_stats:
    addi x5,  x0, 0
    addi x6,  x0, 0
    addi x27, x0, 0
    addi x28, x10, 0
    addi x29, x11, 0
cs_loop:
    lw   x30, 0(x28)
    add  x5,  x5,  x30
    xor  x6,  x6,  x30
    blt  x27, x30, cs_setmax
cs_next:
    addi x28, x28, 4
    addi x29, x29, -1
    bne  x29, x0, cs_loop
    addi x10, x5,  0
    addi x11, x6,  0
    addi x12, x27, 0
    jalr x0, x1, 0

cs_setmax:
    addi x27, x30, 0
    j    cs_next





.section .text
.globl _start

_start:
    li   x31, 0

    lui  x7, 0x80000
    addi x7, x7, 0
    addi x8, x7, 0x100

    addi x10, x8, 0
    li   x11, 4

    la   x6, fill_stats
    jalr x1, x6, 0

    li   x13, 10
    bne  x10, x13, f1
    li   x14, 4
    bne  x11, x14, f2
    bne  x12, x14, f4
    j    wr

f1:
    ori  x31, x31, 1
    li   x14, 4
    bne  x11, x14, f2
    bne  x12, x14, f4
    j    wr
f2:
    ori  x31, x31, 2
    bne  x12, x14, f4
    j    wr
f4:
    ori  x31, x31, 4

wr:
    sw   x10, 0(x7)
    sw   x11, 4(x7)
    sw   x12, 8(x7)
    sw   x31, 12(x7)
    li   x15, 1
    sw   x15, 16(x7)

end:
    jal  x0, end


fill_stats:
    addi x16, x10, 0
    addi x14, x11, 0
    li   x15, 1
    li   x17, 0
    li   x18, 0
    li   x19, 0

L:
    sw   x15, 0(x16)
    add  x17, x17, x15
    xor  x18, x18, x15
    blt  x19, x15, M
N:
    addi x16, x16, 4
    addi x15, x15, 1
    addi x14, x14, -1
    bne  x14, x0, L

    addi x10, x17, 0
    addi x11, x18, 0
    addi x12, x19, 0
    jalr x0, x1, 0

M:
    addi x19, x15, 0
    j    N








.section .text
.globl _start

_start:
    li   x31, 0
    lui  x7, 0x80000
    addi x7, x7, 0

    jal  x1, funcA
Aret:
    jal  x1, funcB
Bret:
    la   x10, expect_ra
    lw   x11, 0(x10)
    bne  x1, x11, fail
    j    out

fail:
    li   x31, 1

out:
    sw   x31, 0(x7)
    li   x14, 1
    sw   x14, 16(x7)
end:
    jal  x0, end

funcA:
    jalr x0, x1, 0

funcB:
    jalr x0, x1, 0

.align 2
expect_ra:
    .word Bret











