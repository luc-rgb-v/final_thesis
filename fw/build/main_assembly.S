	.file	"main.cpp"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	_Z28maxim_peaks_above_min_heightPlS_S_ll
	.type	_Z28maxim_peaks_above_min_heightPlS_S_ll, @function
_Z28maxim_peaks_above_min_heightPlS_S_ll:
	sw	zero,0(a1)
	li	a5,2
	addi	t6,a3,-1
	li	a6,1
	ble	a3,a5,.L1
.L7:
	slli	a5,a6,2
	add	a5,a2,a5
	lw	t1,0(a5)
	addi	t3,a6,1
	ble	t1,a4,.L15
	lw	a7,-4(a5)
	bgt	t1,a7,.L19
.L15:
	mv	a6,t3
	blt	a6,t6,.L7
.L1:
	ret
.L19:
	ble	a3,t3,.L15
	sub	t5,a3,a6
	li	a7,1
	j	.L4
.L6:
	addi	a7,a7,1
	add	t3,a7,a6
	beq	a7,t5,.L5
.L4:
	lw	t4,4(a5)
	addi	a5,a5,4
	beq	t1,t4,.L6
.L5:
	ble	a3,t3,.L15
	slli	a5,t3,2
	add	a5,a2,a5
	lw	a5,0(a5)
	ble	t1,a5,.L15
	lw	a5,0(a1)
	li	t1,14
	bgt	a5,t1,.L15
	addi	t1,a5,1
	slli	a5,a5,2
	addi	a7,a7,1
	sw	t1,0(a1)
	add	a5,a0,a5
	sw	a6,0(a5)
	add	a6,a6,a7
	blt	a6,t6,.L7
	ret
	.size	_Z28maxim_peaks_above_min_heightPlS_S_ll, .-_Z28maxim_peaks_above_min_heightPlS_S_ll
	.align	2
	.globl	_Z17maxim_sort_ascendPll
	.type	_Z17maxim_sort_ascendPll, @function
_Z17maxim_sort_ascendPll:
	li	a7,1
	addi	t1,a0,4
	ble	a1,a7,.L20
.L25:
	lw	a6,0(t1)
	mv	a5,t1
	mv	a4,a7
.L22:
	lw	a3,-4(a5)
	addi	a4,a4,-1
	mv	a2,a5
	ble	a3,a6,.L23
	sw	a3,0(a5)
	addi	a5,a2,-4
	bne	a4,zero,.L22
	mv	a2,a0
.L23:
	sw	a6,0(a2)
	addi	a7,a7,1
	addi	t1,t1,4
	bne	a1,a7,.L25
.L20:
	ret
	.size	_Z17maxim_sort_ascendPll, .-_Z17maxim_sort_ascendPll
	.align	2
	.globl	_Z26maxim_sort_indices_descendPlS_l
	.type	_Z26maxim_sort_indices_descendPlS_l, @function
_Z26maxim_sort_indices_descendPlS_l:
	li	t4,1
	addi	t5,a1,4
	ble	a2,t4,.L30
.L35:
	lw	t6,0(t5)
	mv	a5,t5
	mv	a3,t4
	slli	t3,t6,2
	add	t3,a0,t3
.L32:
	lw	a6,-4(a5)
	lw	t1,0(t3)
	addi	a3,a3,-1
	slli	a4,a6,2
	add	a4,a0,a4
	lw	a7,0(a4)
	mv	a4,a5
	ble	t1,a7,.L33
	sw	a6,0(a5)
	addi	a5,a4,-4
	bne	a3,zero,.L32
	mv	a4,a1
.L33:
	sw	t6,0(a4)
	addi	t4,t4,1
	addi	t5,t5,4
	bne	a2,t4,.L35
.L30:
	ret
	.size	_Z26maxim_sort_indices_descendPlS_l, .-_Z26maxim_sort_indices_descendPlS_l
	.align	2
	.globl	_Z24maxim_remove_close_peaksPlS_S_l
	.type	_Z24maxim_remove_close_peaksPlS_S_l, @function
_Z24maxim_remove_close_peaksPlS_S_l:
	mv	a5,a2
	lw	a2,0(a1)
	addi	sp,sp,-32
	sw	s0,24(sp)
	sw	s1,20(sp)
	mv	s0,a1
	mv	s1,a0
	mv	a1,a0
	mv	a0,a5
	sw	ra,28(sp)
	sw	a3,12(sp)
	call	_Z26maxim_sort_indices_descendPlS_l
	lw	a6,0(s0)
	blt	a6,zero,.L47
	lw	a3,12(sp)
	li	a0,-1
	mv	a1,a0
	mv	a7,a0
	mv	t1,s1
	neg	t3,a3
.L46:
	addi	a1,a1,1
	sw	a1,0(s0)
	bge	a1,a6,.L41
	slli	a6,a6,2
	add	a6,s1,a6
	mv	a4,t1
.L45:
	lw	a5,0(a4)
	mv	a2,a0
	beq	a0,a7,.L42
	lw	a2,-4(t1)
.L42:
	sub	a5,a5,a2
	bgt	a5,a3,.L43
	ble	t3,a5,.L44
.L43:
	lw	a5,0(s0)
	addi	a2,a5,1
	sw	a2,0(s0)
	lw	a2,0(a4)
	slli	a5,a5,2
	add	a5,s1,a5
	sw	a2,0(a5)
.L44:
	addi	a4,a4,4
	bne	a4,a6,.L45
	lw	a6,0(s0)
	addi	a0,a0,1
	addi	t1,t1,4
	blt	a1,a6,.L46
.L47:
	mv	a1,a6
.L41:
	lw	s0,24(sp)
	lw	ra,28(sp)
	mv	a0,s1
	lw	s1,20(sp)
	addi	sp,sp,32
	tail	_Z17maxim_sort_ascendPll
	.size	_Z24maxim_remove_close_peaksPlS_S_l, .-_Z24maxim_remove_close_peaksPlS_S_l
	.align	2
	.globl	_Z16maxim_find_peaksPlS_S_llll
	.type	_Z16maxim_find_peaksPlS_S_llll, @function
_Z16maxim_find_peaksPlS_S_llll:
	addi	sp,sp,-32
	sw	a5,12(sp)
	sw	a6,8(sp)
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	a0,4(sp)
	mv	s0,a1
	sw	a2,0(sp)
	call	_Z28maxim_peaks_above_min_heightPlS_S_ll
	lw	a3,12(sp)
	lw	a2,0(sp)
	lw	a0,4(sp)
	mv	a1,s0
	call	_Z24maxim_remove_close_peaksPlS_S_l
	lw	a5,0(s0)
	lw	a6,8(sp)
	ble	a5,a6,.L53
	mv	a5,a6
.L53:
	lw	ra,28(sp)
	sw	a5,0(s0)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	_Z16maxim_find_peaksPlS_S_llll, .-_Z16maxim_find_peaksPlS_S_llll
	.align	2
	.globl	_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_
	.type	_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_, @function
_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_:
	addi	sp,sp,-192
	sw	ra,188(sp)
	sw	zero,44(sp)
	ble	a1,zero,.L116
	sw	s0,184(sp)
	sw	s1,180(sp)
	sw	s2,176(sp)
	sw	s3,172(sp)
	sw	s4,168(sp)
	sw	s5,164(sp)
	sw	s6,160(sp)
	sw	s7,156(sp)
	sw	s8,152(sp)
	sw	s11,140(sp)
	li	a7,100
	mv	s0,a1
	bgt	a1,a7,.L117
.L58:
	mv	s2,a0
	mv	t1,a0
	li	a7,0
	li	t3,0
.L59:
	lhu	t4,0(t1)
	addi	a7,a7,1
	addi	t1,t1,2
	add	t3,t3,t4
	bgt	s0,a7,.L59
	mv	s4,a0
	mv	s3,a1
	mv	a0,t3
	mv	a1,s0
	lui	s1,%hi(.LANCHOR0)
	sw	a4,28(sp)
	mv	s11,a3
	mv	s7,a2
	mv	s5,a6
	mv	s8,a5
	addi	s1,s1,%lo(.LANCHOR0)
	call	__udivsi3
	mv	a4,s4
	mv	a2,s1
	li	a3,0
.L60:
	lhu	a5,0(a4)
	addi	a3,a3,1
	addi	a4,a4,2
	sub	a5,a0,a5
	sw	a5,0(a2)
	addi	a2,a2,4
	bgt	s0,a3,.L60
	li	a5,4
	ble	s3,a5,.L64
	lw	a1,0(s1)
	lw	a3,4(s1)
	lw	a2,8(s1)
	addi	a7,s0,-4
	mv	a5,s1
	li	a4,0
	j	.L63
.L88:
	mv	a2,a6
.L63:
	lw	a6,12(a5)
	add	a1,a1,a3
	add	a1,a1,a2
	add	a1,a1,a6
	srai	a0,a1,31
	andi	a0,a0,3
	add	a1,a0,a1
	srai	a1,a1,2
	sw	a1,0(a5)
	addi	a4,a4,1
	mv	a1,a3
	addi	a5,a5,4
	mv	a3,a2
	blt	a4,a7,.L88
.L64:
	mv	a4,s1
	li	a0,0
	li	a5,0
.L62:
	lw	a3,0(a4)
	addi	a5,a5,1
	addi	a4,a4,4
	add	a0,a0,a3
	bgt	s0,a5,.L62
	mv	a1,s0
	call	__divsi3
	li	a5,60
	mv	a4,a0
	bgt	a0,a5,.L118
	li	a5,30
	blt	a4,a5,.L119
.L66:
	addi	s4,sp,68
	mv	a5,s4
.L67:
	sw	zero,0(a5)
	addi	a3,sp,128
	addi	a5,a5,4
	bne	a3,a5,.L67
	addi	a1,sp,44
	mv	a3,s0
	mv	a2,s1
	addi	a0,sp,68
	call	_Z28maxim_peaks_above_min_heightPlS_S_ll
	addi	a1,sp,44
	mv	a2,s1
	addi	a0,sp,68
	li	a3,4
	call	_Z24maxim_remove_close_peaksPlS_S_l
	lw	s3,44(sp)
	li	a5,15
	mv	s6,s3
	bgt	s3,a5,.L120
	li	a4,1
	ble	s3,a4,.L90
.L122:
	lw	a2,68(sp)
	addi	a3,sp,72
	li	a1,0
	li	a0,0
	li	a6,7
.L71:
	mv	a5,a2
	lw	a2,0(a3)
	addi	a4,a4,1
	addi	a3,a3,4
	sub	a5,a2,a5
	ble	a5,a6,.L70
	add	a0,a0,a5
	addi	a1,a1,1
.L70:
	bgt	s6,a4,.L71
	beq	a1,zero,.L90
	call	__divsi3
	mv	a1,a0
	li	a0,1500
	call	__divsi3
	li	a5,1
	j	.L69
.L90:
	li	a0,-999
	li	a5,0
.L69:
	sw	a0,0(s8)
	sb	a5,0(s5)
	addi	s5,s1,400
	mv	a5,s7
	mv	a2,s5
	mv	a3,s1
	li	a4,0
.L72:
	lhu	a0,0(s2)
	lhu	a1,0(a5)
	addi	a4,a4,1
	sw	a0,0(a3)
	sw	a1,0(a2)
	addi	s2,s2,2
	addi	a3,a3,4
	addi	a5,a5,2
	addi	a2,a2,4
	bgt	s0,a4,.L72
	sw	zero,48(sp)
	sw	zero,52(sp)
	sw	zero,56(sp)
	sw	zero,60(sp)
	sw	zero,64(sp)
	ble	s3,zero,.L73
	addi	a5,sp,68
	li	a4,0
	j	.L75
.L74:
	bge	a4,s6,.L121
.L75:
	lw	a3,0(a5)
	addi	a4,a4,1
	addi	a5,a5,4
	blt	a3,s0,.L74
.L77:
	li	a5,-999
	sw	a5,0(s11)
	lw	a5,28(sp)
	sb	zero,0(a5)
	lw	s0,184(sp)
	lw	ra,188(sp)
	lw	s1,180(sp)
	lw	s2,176(sp)
	lw	s3,172(sp)
	lw	s4,168(sp)
	lw	s5,164(sp)
	lw	s6,160(sp)
	lw	s7,156(sp)
	lw	s8,152(sp)
	lw	s11,140(sp)
	addi	sp,sp,192
	jr	ra
.L120:
	li	a4,1
	mv	s6,a5
	bgt	s3,a4,.L122
	j	.L90
.L119:
	mv	a4,a5
	j	.L66
.L118:
	mv	a4,a5
	li	a5,30
	bge	a4,a5,.L66
	j	.L119
.L117:
	mv	s0,a7
	j	.L58
.L121:
	li	a5,1
	beq	s3,a5,.L73
	sw	s9,148(sp)
	sw	s10,144(sp)
	addi	s6,s6,-1
	li	s2,0
	li	s9,0
	li	s3,0
	li	s7,0
	li	s10,3
	j	.L85
.L78:
	addi	s4,s4,4
	bge	s7,s6,.L123
.L85:
	lw	a1,4(s4)
	lw	a6,0(s4)
	addi	s7,s7,1
	sub	s8,a1,a6
	ble	s8,s10,.L78
	not	a5,a6
	srai	a5,a5,31
	and	a5,a6,a5
	mv	a0,a1
	ble	a1,s0,.L80
	mv	a0,s0
.L80:
	ble	a0,a5,.L91
	slli	a4,a5,2
	li	a7,-2147483648
	add	a3,s1,a4
	mv	t1,a7
	add	a4,a4,s5
.L84:
	lw	a2,0(a3)
	addi	a3,a3,4
	ble	a2,a7,.L82
	mv	a7,a2
	mv	s2,a5
.L82:
	lw	a2,0(a4)
	addi	a4,a4,4
	ble	a2,t1,.L83
	mv	t1,a2
	mv	s9,a5
.L83:
	addi	a5,a5,1
	bne	a0,a5,.L84
.L81:
	slli	a4,a6,2
	slli	a1,a1,2
	add	a5,s1,a1
	add	a4,s1,a4
	lw	a3,400(a4)
	lw	a0,400(a5)
	sub	a1,s9,a6
	sw	a7,24(sp)
	sub	a0,a0,a3
	sw	t1,20(sp)
	sw	a5,16(sp)
	sw	a4,12(sp)
	sw	a6,8(sp)
	sw	a3,4(sp)
	call	__mulsi3
	mv	a1,s8
	call	__divsi3
	lw	a4,12(sp)
	lw	a5,16(sp)
	lw	a6,8(sp)
	lw	a4,0(a4)
	lw	a5,0(a5)
	lw	a3,4(sp)
	sub	a1,s2,a6
	sw	a4,4(sp)
	add	a3,a3,a0
	sub	a0,a5,a4
	sw	a3,8(sp)
	call	__mulsi3
	mv	a1,s8
	call	__divsi3
	slli	a5,s9,2
	add	a5,s1,a5
	lw	a4,4(sp)
	lw	a3,8(sp)
	lw	a5,400(a5)
	lw	a1,24(sp)
	add	s8,a4,a0
	sub	a0,a5,a3
	call	__mulsi3
	slli	a5,s2,2
	add	a5,s1,a5
	lw	a4,0(a5)
	lw	a1,20(sp)
	srai	a5,a0,7
	sub	a0,a4,s8
	sw	a5,4(sp)
	call	__mulsi3
	lw	a5,4(sp)
	srai	a1,a0,7
	sgt	a4,a1,zero
	snez	a3,a5
	and	a4,a4,a3
	beq	a4,zero,.L78
	slti	a4,s3,5
	beq	a4,zero,.L78
	slli	a0,a5,1
	add	a0,a0,a5
	slli	a0,a0,3
	add	a0,a0,a5
	slli	s8,s3,2
	slli	a0,a0,2
	add	s8,sp,s8
	call	__divsi3
	sw	a0,48(s8)
	addi	s3,s3,1
	addi	s4,s4,4
	blt	s7,s6,.L85
.L123:
	mv	a1,s3
	addi	a0,sp,48
	call	_Z17maxim_sort_ascendPll
	li	a4,3
	srai	a5,s3,1
	ble	s3,a4,.L86
	slli	a4,a5,2
	slli	a5,a5,2
	add	a4,sp,a4
	add	a5,sp,a5
	lw	a5,48(a5)
	lw	a4,44(a4)
	add	a4,a4,a5
	srli	a5,a4,31
	add	a5,a5,a4
	srai	a5,a5,1
.L87:
	addi	a4,a5,-3
	li	a3,180
	bgtu	a4,a3,.L115
	lui	a4,%hi(.LANCHOR1)
	addi	a4,a4,%lo(.LANCHOR1)
	add	a5,a4,a5
	lbu	a4,0(a5)
	li	a5,1
	sw	a4,0(s11)
	lw	a4,28(sp)
	sb	a5,0(a4)
	lw	s0,184(sp)
	lw	ra,188(sp)
	lw	s1,180(sp)
	lw	s2,176(sp)
	lw	s3,172(sp)
	lw	s4,168(sp)
	lw	s5,164(sp)
	lw	s6,160(sp)
	lw	s7,156(sp)
	lw	s8,152(sp)
	lw	s9,148(sp)
	lw	s10,144(sp)
	lw	s11,140(sp)
	addi	sp,sp,192
	jr	ra
.L116:
	li	a2,-999
	sw	a2,0(a3)
	sb	zero,0(a4)
	sw	a2,0(a5)
	sb	zero,0(a6)
	lw	ra,188(sp)
	addi	sp,sp,192
	jr	ra
.L86:
	beq	s3,zero,.L115
	slli	a5,a5,2
	add	a5,sp,a5
	lw	a5,48(a5)
	j	.L87
.L115:
	lw	s9,148(sp)
	lw	s10,144(sp)
	j	.L77
.L91:
	li	a7,-2147483648
	mv	t1,a7
	j	.L81
.L73:
	li	a1,0
	addi	a0,sp,48
	call	_Z17maxim_sort_ascendPll
	j	.L77
	.size	_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_, .-_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_
	.section	.text.startup,"ax",@progbits
	.align	2
	.globl	main
	.type	main, @function
main:
	lui	a2,%hi(.LANCHOR2)
	addi	sp,sp,-32
	addi	a2,a2,%lo(.LANCHOR2)
	addi	a0,a2,200
	addi	a6,sp,7
	addi	a5,sp,12
	addi	a4,sp,6
	addi	a3,sp,8
	li	a1,100
	sw	ra,28(sp)
	call	_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_
	lw	ra,28(sp)
	li	a0,0
	addi	sp,sp,32
	jr	ra
	.size	main, .-main
	.section	.rodata
	.align	2
	.set	.LANCHOR1,. + 0
	.type	_ZL14uch_spo2_table, @object
	.size	_ZL14uch_spo2_table, 184
_ZL14uch_spo2_table:
	.base64	"X19fYGBgYWFhYWFiYmJiYmNjY2NjY2NjZGRkZGRkZGRkZGRkZGRkZGRkZGRjY2NjY2NjY2JiYmJiYmFhYWFgYGBgX19fXl5eXV1dXFxcW1taWllZWVhYV1dWVlVVVFRTUlJRUVBQT05OTUxMS0pKSUhIR0ZFRURDQkJBQD8+Pj08Ozo5ODg3NjU0MzIxMC8uLSwrKikoJyYlJCMiIR8eHRwbGhkXFhUUExEQDw4MCwoJBwYFAwIB"
	.zero	1
	.data
	.align	2
	.set	.LANCHOR2,. + 0
	.type	_ZL14pun_red_buffer, @object
	.size	_ZL14pun_red_buffer, 200
_ZL14pun_red_buffer:
	.half	-30105
	.half	-30031
	.half	-29823
	.half	-29579
	.half	-29406
	.half	-29360
	.half	-29404
	.half	-29449
	.half	-29415
	.half	-29326
	.half	-29221
	.half	-29140
	.half	-29075
	.half	-29015
	.half	-28935
	.half	-28873
	.half	-28858
	.half	-29137
	.half	-29627
	.half	-29859
	.half	-29797
	.half	-29636
	.half	-29429
	.half	-29274
	.half	-29210
	.half	-29230
	.half	-29265
	.half	-29225
	.half	-29135
	.half	-29055
	.half	-28981
	.half	-28918
	.half	-28858
	.half	-28814
	.half	-28745
	.half	-28769
	.half	-29113
	.half	-29552
	.half	-29727
	.half	-29634
	.half	-29485
	.half	-29335
	.half	-29214
	.half	-29158
	.half	-29173
	.half	-29169
	.half	-29143
	.half	-29093
	.half	-29012
	.half	-28936
	.half	-28885
	.half	-28843
	.half	-28768
	.half	-28777
	.half	-28987
	.half	-29432
	.half	-29703
	.half	-29687
	.half	-29564
	.half	-29426
	.half	-29289
	.half	-29214
	.half	-29195
	.half	-29220
	.half	-29197
	.half	-29144
	.half	-29079
	.half	-29003
	.half	-28955
	.half	-28922
	.half	-28865
	.half	-28820
	.half	-28761
	.half	-28838
	.half	-29229
	.half	-29644
	.half	-29752
	.half	-29668
	.half	-29533
	.half	-29400
	.half	-29285
	.half	-29244
	.half	-29258
	.half	-29262
	.half	-29217
	.half	-29151
	.half	-29082
	.half	-29015
	.half	-28955
	.half	-28911
	.half	-28853
	.half	-28796
	.half	-28761
	.half	-28695
	.half	-28766
	.half	-29159
	.half	-29606
	.half	-29723
	.half	-29637
	.half	-29528
	.type	_ZL13pun_ir_buffer, @object
	.size	_ZL13pun_ir_buffer, 200
_ZL13pun_ir_buffer:
	.half	-31639
	.half	-31410
	.half	-30883
	.half	-30333
	.half	-29912
	.half	-29805
	.half	-29929
	.half	-30019
	.half	-29936
	.half	-29740
	.half	-29525
	.half	-29328
	.half	-29143
	.half	-29016
	.half	-28871
	.half	-28683
	.half	-28657
	.half	-29349
	.half	-30471
	.half	-30968
	.half	-30799
	.half	-30382
	.half	-29899
	.half	-29547
	.half	-29418
	.half	-29470
	.half	-29517
	.half	-29425
	.half	-29251
	.half	-29036
	.half	-28873
	.half	-28739
	.half	-28613
	.half	-28454
	.half	-28307
	.half	-28407
	.half	-29212
	.half	-30239
	.half	-30599
	.half	-30388
	.half	-30040
	.half	-29669
	.half	-29395
	.half	-29286
	.half	-29360
	.half	-29389
	.half	-29300
	.half	-29150
	.half	-28993
	.half	-28847
	.half	-28711
	.half	-28618
	.half	-28497
	.half	-28443
	.half	-28986
	.half	-30046
	.half	-30645
	.half	-30567
	.half	-30273
	.half	-29961
	.half	-29659
	.half	-29486
	.half	-29474
	.half	-29519
	.half	-29505
	.half	-29353
	.half	-29195
	.half	-29030
	.half	-28920
	.half	-28844
	.half	-28745
	.half	-28637
	.half	-28504
	.half	-28697
	.half	-29620
	.half	-30564
	.half	-30788
	.half	-30544
	.half	-30246
	.half	-29938
	.half	-29670
	.half	-29602
	.half	-29671
	.half	-29667
	.half	-29565
	.half	-29411
	.half	-29258
	.half	-29097
	.half	-28984
	.half	-28875
	.half	-28755
	.half	-28607
	.half	-28481
	.half	-28362
	.half	-28560
	.half	-29502
	.half	-30502
	.half	-30750
	.half	-30532
	.half	-30228
	.bss
	.align	2
	.set	.LANCHOR0,. + 0
	.type	_ZL4an_x, @object
	.size	_ZL4an_x, 400
_ZL4an_x:
	.zero	400
	.type	_ZL4an_y, @object
	.size	_ZL4an_y, 400
_ZL4an_y:
	.zero	400
	.globl	__mulsi3
	.globl	__divsi3
	.globl	__udivsi3
	.ident	"GCC: () 15.1.0"
	.section	.note.GNU-stack,"",@progbits
