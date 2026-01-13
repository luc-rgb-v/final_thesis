.section .text
.globl _start
_start:
	lui	sp,0x80004
	jal	ra,caller
1:	j	1b

caller:
	addi	sp,sp,-48
	lui	t0,0x80000
	addi	t0,t0,0x01c
	sw	t0,44(sp)
	lui	t1,0x80004
	sw	t1,40(sp)
	lui	t2,0x80000
	addi	t2,t2,0x000
	sw	t2,36(sp)
	sw	x0,32(sp)
	lui	t3,0x80000
	addi	t3,t3,0x000
	sw	t3,24(sp)
	lui	t4,0x0
	addi	t4,t4,0x0f
	sw	t4,12(sp)
	lui	t5,0x1
	sw	t5,8(sp)
	jal	ra,callee
	lw	ra,44(sp)
	lw	x2,40(sp)
	lw	x3,36(sp)
	lw	x4,32(sp)
	lw	x5,24(sp)
	lw	x6,20(sp)
	lw	x7,16(sp)
	lw	x8,12(sp)
	lw	x9,8(sp)
	lw	x10,4(sp)
	lw	x11,0(sp)
	addi	sp,sp,48
	jalr	x0,ra,0

callee:
	addi	sp,sp,-32
	lui	t0,0x80000
	addi	t0,t0,0x054
	sw	t0,44(sp)
	lui	t1,0x80003
	addi	t1,t1,0x0dc
	sw	t1,40(sp)
	lui	t2,0x0
	addi	t2,t2,0x03
	sw	t2,36(sp)
	lui	t3,0x0
	addi	t3,t3,0x02
	sw	t3,32(sp)
	lui	t4,0x0
	addi	t4,t4,0x01
	sw	t4,28(sp)
	lui	t5,0x80003
	addi	t5,t5,0x0bc
	sw	t5,24(sp)
	addi	sp,sp,32
	jalr	x0,ra,0