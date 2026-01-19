
build/main.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <_start>:
80000000:	00011117          	auipc	sp,0x11
80000004:	80010113          	addi	sp,sp,-2048 # 80010800 <_stack_top>
80000008:	00010297          	auipc	t0,0x10
8000000c:	18828293          	addi	t0,t0,392 # 80010190 <_ZL4an_x>
80000010:	00010317          	auipc	t1,0x10
80000014:	4a030313          	addi	t1,t1,1184 # 800104b0 <_bss_end>
80000018:	0062d863          	bge	t0,t1,80000028 <_start+0x28>
8000001c:	0002a023          	sw	zero,0(t0)
80000020:	00428293          	addi	t0,t0,4
80000024:	ff5ff06f          	j	80000018 <_start+0x18>
80000028:	04d000ef          	jal	80000874 <main>
8000002c:	0000006f          	j	8000002c <_start+0x2c>

80000030 <_Z28maxim_peaks_above_min_heightPlS_S_ll>:
80000030:	0005a023          	sw	zero,0(a1)
80000034:	00200793          	li	a5,2
80000038:	fff68f93          	addi	t6,a3,-1
8000003c:	00100813          	li	a6,1
80000040:	02d7d463          	bge	a5,a3,80000068 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x38>
80000044:	00281793          	slli	a5,a6,0x2
80000048:	00f607b3          	add	a5,a2,a5
8000004c:	0007a303          	lw	t1,0(a5)
80000050:	00180e13          	addi	t3,a6,1
80000054:	00675663          	bge	a4,t1,80000060 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x30>
80000058:	ffc7a883          	lw	a7,-4(a5)
8000005c:	0068c863          	blt	a7,t1,8000006c <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x3c>
80000060:	000e0813          	mv	a6,t3
80000064:	fff840e3          	blt	a6,t6,80000044 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x14>
80000068:	00008067          	ret
8000006c:	fede5ae3          	bge	t3,a3,80000060 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x30>
80000070:	41068f33          	sub	t5,a3,a6
80000074:	00100893          	li	a7,1
80000078:	0100006f          	j	80000088 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x58>
8000007c:	00188893          	addi	a7,a7,1
80000080:	01088e33          	add	t3,a7,a6
80000084:	01e88863          	beq	a7,t5,80000094 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x64>
80000088:	0047ae83          	lw	t4,4(a5)
8000008c:	00478793          	addi	a5,a5,4
80000090:	ffd306e3          	beq	t1,t4,8000007c <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x4c>
80000094:	fcde56e3          	bge	t3,a3,80000060 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x30>
80000098:	002e1793          	slli	a5,t3,0x2
8000009c:	00f607b3          	add	a5,a2,a5
800000a0:	0007a783          	lw	a5,0(a5)
800000a4:	fa67dee3          	bge	a5,t1,80000060 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x30>
800000a8:	0005a783          	lw	a5,0(a1)
800000ac:	00e00313          	li	t1,14
800000b0:	faf348e3          	blt	t1,a5,80000060 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x30>
800000b4:	00178313          	addi	t1,a5,1
800000b8:	00279793          	slli	a5,a5,0x2
800000bc:	00188893          	addi	a7,a7,1
800000c0:	0065a023          	sw	t1,0(a1)
800000c4:	00f507b3          	add	a5,a0,a5
800000c8:	0107a023          	sw	a6,0(a5)
800000cc:	01180833          	add	a6,a6,a7
800000d0:	f7f84ae3          	blt	a6,t6,80000044 <_Z28maxim_peaks_above_min_heightPlS_S_ll+0x14>
800000d4:	00008067          	ret

800000d8 <_Z17maxim_sort_ascendPll>:
800000d8:	00100893          	li	a7,1
800000dc:	00450313          	addi	t1,a0,4
800000e0:	04b8d063          	bge	a7,a1,80000120 <_Z17maxim_sort_ascendPll+0x48>
800000e4:	00032803          	lw	a6,0(t1)
800000e8:	00030793          	mv	a5,t1
800000ec:	00088713          	mv	a4,a7
800000f0:	ffc7a683          	lw	a3,-4(a5)
800000f4:	fff70713          	addi	a4,a4,-1
800000f8:	00078613          	mv	a2,a5
800000fc:	00d85a63          	bge	a6,a3,80000110 <_Z17maxim_sort_ascendPll+0x38>
80000100:	00d7a023          	sw	a3,0(a5)
80000104:	ffc60793          	addi	a5,a2,-4
80000108:	fe0714e3          	bnez	a4,800000f0 <_Z17maxim_sort_ascendPll+0x18>
8000010c:	00050613          	mv	a2,a0
80000110:	01062023          	sw	a6,0(a2)
80000114:	00188893          	addi	a7,a7,1
80000118:	00430313          	addi	t1,t1,4
8000011c:	fd1594e3          	bne	a1,a7,800000e4 <_Z17maxim_sort_ascendPll+0xc>
80000120:	00008067          	ret

80000124 <_Z26maxim_sort_indices_descendPlS_l>:
80000124:	00100e93          	li	t4,1
80000128:	00458f13          	addi	t5,a1,4
8000012c:	04cedc63          	bge	t4,a2,80000184 <_Z26maxim_sort_indices_descendPlS_l+0x60>
80000130:	000f2f83          	lw	t6,0(t5)
80000134:	000f0793          	mv	a5,t5
80000138:	000e8693          	mv	a3,t4
8000013c:	002f9e13          	slli	t3,t6,0x2
80000140:	01c50e33          	add	t3,a0,t3
80000144:	ffc7a803          	lw	a6,-4(a5)
80000148:	000e2303          	lw	t1,0(t3)
8000014c:	fff68693          	addi	a3,a3,-1
80000150:	00281713          	slli	a4,a6,0x2
80000154:	00e50733          	add	a4,a0,a4
80000158:	00072883          	lw	a7,0(a4)
8000015c:	00078713          	mv	a4,a5
80000160:	0068da63          	bge	a7,t1,80000174 <_Z26maxim_sort_indices_descendPlS_l+0x50>
80000164:	0107a023          	sw	a6,0(a5)
80000168:	ffc70793          	addi	a5,a4,-4
8000016c:	fc069ce3          	bnez	a3,80000144 <_Z26maxim_sort_indices_descendPlS_l+0x20>
80000170:	00058713          	mv	a4,a1
80000174:	01f72023          	sw	t6,0(a4)
80000178:	001e8e93          	addi	t4,t4,1
8000017c:	004f0f13          	addi	t5,t5,4
80000180:	fbd618e3          	bne	a2,t4,80000130 <_Z26maxim_sort_indices_descendPlS_l+0xc>
80000184:	00008067          	ret

80000188 <_Z24maxim_remove_close_peaksPlS_S_l>:
80000188:	00060793          	mv	a5,a2
8000018c:	0005a603          	lw	a2,0(a1)
80000190:	fe010113          	addi	sp,sp,-32
80000194:	00812c23          	sw	s0,24(sp)
80000198:	00912a23          	sw	s1,20(sp)
8000019c:	00058413          	mv	s0,a1
800001a0:	00050493          	mv	s1,a0
800001a4:	00050593          	mv	a1,a0
800001a8:	00078513          	mv	a0,a5
800001ac:	00112e23          	sw	ra,28(sp)
800001b0:	00d12623          	sw	a3,12(sp)
800001b4:	f71ff0ef          	jal	80000124 <_Z26maxim_sort_indices_descendPlS_l>
800001b8:	00042803          	lw	a6,0(s0)
800001bc:	08084263          	bltz	a6,80000240 <_Z24maxim_remove_close_peaksPlS_S_l+0xb8>
800001c0:	00c12683          	lw	a3,12(sp)
800001c4:	fff00513          	li	a0,-1
800001c8:	00050593          	mv	a1,a0
800001cc:	00050893          	mv	a7,a0
800001d0:	00048313          	mv	t1,s1
800001d4:	40d00e33          	neg	t3,a3
800001d8:	00158593          	addi	a1,a1,1
800001dc:	00b42023          	sw	a1,0(s0)
800001e0:	0705d263          	bge	a1,a6,80000244 <_Z24maxim_remove_close_peaksPlS_S_l+0xbc>
800001e4:	00281813          	slli	a6,a6,0x2
800001e8:	01048833          	add	a6,s1,a6
800001ec:	00030713          	mv	a4,t1
800001f0:	00072783          	lw	a5,0(a4)
800001f4:	00050613          	mv	a2,a0
800001f8:	01150463          	beq	a0,a7,80000200 <_Z24maxim_remove_close_peaksPlS_S_l+0x78>
800001fc:	ffc32603          	lw	a2,-4(t1)
80000200:	40c787b3          	sub	a5,a5,a2
80000204:	00f6c463          	blt	a3,a5,8000020c <_Z24maxim_remove_close_peaksPlS_S_l+0x84>
80000208:	03c7d063          	bge	a5,t3,80000228 <_Z24maxim_remove_close_peaksPlS_S_l+0xa0>
8000020c:	00042783          	lw	a5,0(s0)
80000210:	00178613          	addi	a2,a5,1
80000214:	00c42023          	sw	a2,0(s0)
80000218:	00072603          	lw	a2,0(a4)
8000021c:	00279793          	slli	a5,a5,0x2
80000220:	00f487b3          	add	a5,s1,a5
80000224:	00c7a023          	sw	a2,0(a5)
80000228:	00470713          	addi	a4,a4,4
8000022c:	fd0712e3          	bne	a4,a6,800001f0 <_Z24maxim_remove_close_peaksPlS_S_l+0x68>
80000230:	00042803          	lw	a6,0(s0)
80000234:	00150513          	addi	a0,a0,1
80000238:	00430313          	addi	t1,t1,4
8000023c:	f905cee3          	blt	a1,a6,800001d8 <_Z24maxim_remove_close_peaksPlS_S_l+0x50>
80000240:	00080593          	mv	a1,a6
80000244:	01812403          	lw	s0,24(sp)
80000248:	01c12083          	lw	ra,28(sp)
8000024c:	00048513          	mv	a0,s1
80000250:	01412483          	lw	s1,20(sp)
80000254:	02010113          	addi	sp,sp,32
80000258:	e81ff06f          	j	800000d8 <_Z17maxim_sort_ascendPll>

8000025c <_Z16maxim_find_peaksPlS_S_llll>:
8000025c:	fe010113          	addi	sp,sp,-32
80000260:	00f12623          	sw	a5,12(sp)
80000264:	01012423          	sw	a6,8(sp)
80000268:	00112e23          	sw	ra,28(sp)
8000026c:	00812c23          	sw	s0,24(sp)
80000270:	00a12223          	sw	a0,4(sp)
80000274:	00058413          	mv	s0,a1
80000278:	00c12023          	sw	a2,0(sp)
8000027c:	db5ff0ef          	jal	80000030 <_Z28maxim_peaks_above_min_heightPlS_S_ll>
80000280:	00c12683          	lw	a3,12(sp)
80000284:	00012603          	lw	a2,0(sp)
80000288:	00412503          	lw	a0,4(sp)
8000028c:	00040593          	mv	a1,s0
80000290:	ef9ff0ef          	jal	80000188 <_Z24maxim_remove_close_peaksPlS_S_l>
80000294:	00042783          	lw	a5,0(s0)
80000298:	00812803          	lw	a6,8(sp)
8000029c:	00f85463          	bge	a6,a5,800002a4 <_Z16maxim_find_peaksPlS_S_llll+0x48>
800002a0:	00080793          	mv	a5,a6
800002a4:	01c12083          	lw	ra,28(sp)
800002a8:	00f42023          	sw	a5,0(s0)
800002ac:	01812403          	lw	s0,24(sp)
800002b0:	02010113          	addi	sp,sp,32
800002b4:	00008067          	ret

800002b8 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_>:
800002b8:	f4010113          	addi	sp,sp,-192
800002bc:	0a112e23          	sw	ra,188(sp)
800002c0:	02012623          	sw	zero,44(sp)
800002c4:	54b05a63          	blez	a1,80000818 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x560>
800002c8:	0a812c23          	sw	s0,184(sp)
800002cc:	0a912a23          	sw	s1,180(sp)
800002d0:	0b212823          	sw	s2,176(sp)
800002d4:	0b312623          	sw	s3,172(sp)
800002d8:	0b412423          	sw	s4,168(sp)
800002dc:	0b512223          	sw	s5,164(sp)
800002e0:	0b612023          	sw	s6,160(sp)
800002e4:	09712e23          	sw	s7,156(sp)
800002e8:	09812c23          	sw	s8,152(sp)
800002ec:	09b12623          	sw	s11,140(sp)
800002f0:	06400893          	li	a7,100
800002f4:	00058413          	mv	s0,a1
800002f8:	2ab8cc63          	blt	a7,a1,800005b0 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x2f8>
800002fc:	00050913          	mv	s2,a0
80000300:	00050313          	mv	t1,a0
80000304:	00000893          	li	a7,0
80000308:	00000e13          	li	t3,0
8000030c:	00035e83          	lhu	t4,0(t1)
80000310:	00188893          	addi	a7,a7,1
80000314:	00230313          	addi	t1,t1,2
80000318:	01de0e33          	add	t3,t3,t4
8000031c:	fe88c8e3          	blt	a7,s0,8000030c <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x54>
80000320:	00050a13          	mv	s4,a0
80000324:	00058993          	mv	s3,a1
80000328:	000e0513          	mv	a0,t3
8000032c:	00040593          	mv	a1,s0
80000330:	800104b7          	lui	s1,0x80010
80000334:	00e12e23          	sw	a4,28(sp)
80000338:	00068d93          	mv	s11,a3
8000033c:	00060b93          	mv	s7,a2
80000340:	00080a93          	mv	s5,a6
80000344:	00078c13          	mv	s8,a5
80000348:	19048493          	addi	s1,s1,400 # 80010190 <_ZL4an_x>
8000034c:	590000ef          	jal	800008dc <__hidden___udivsi3>
80000350:	000a0713          	mv	a4,s4
80000354:	00048613          	mv	a2,s1
80000358:	00000693          	li	a3,0
8000035c:	00075783          	lhu	a5,0(a4)
80000360:	00168693          	addi	a3,a3,1
80000364:	00270713          	addi	a4,a4,2
80000368:	40f507b3          	sub	a5,a0,a5
8000036c:	00f62023          	sw	a5,0(a2)
80000370:	00460613          	addi	a2,a2,4
80000374:	fe86c4e3          	blt	a3,s0,8000035c <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0xa4>
80000378:	00400793          	li	a5,4
8000037c:	0537de63          	bge	a5,s3,800003d8 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x120>
80000380:	0004a583          	lw	a1,0(s1)
80000384:	0044a683          	lw	a3,4(s1)
80000388:	0084a603          	lw	a2,8(s1)
8000038c:	ffc40893          	addi	a7,s0,-4
80000390:	00048793          	mv	a5,s1
80000394:	00000713          	li	a4,0
80000398:	0080006f          	j	800003a0 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0xe8>
8000039c:	00080613          	mv	a2,a6
800003a0:	00c7a803          	lw	a6,12(a5)
800003a4:	00d585b3          	add	a1,a1,a3
800003a8:	00c585b3          	add	a1,a1,a2
800003ac:	010585b3          	add	a1,a1,a6
800003b0:	41f5d513          	srai	a0,a1,0x1f
800003b4:	00357513          	andi	a0,a0,3
800003b8:	00b505b3          	add	a1,a0,a1
800003bc:	4025d593          	srai	a1,a1,0x2
800003c0:	00b7a023          	sw	a1,0(a5)
800003c4:	00170713          	addi	a4,a4,1
800003c8:	00068593          	mv	a1,a3
800003cc:	00478793          	addi	a5,a5,4
800003d0:	00060693          	mv	a3,a2
800003d4:	fd1744e3          	blt	a4,a7,8000039c <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0xe4>
800003d8:	00048713          	mv	a4,s1
800003dc:	00000513          	li	a0,0
800003e0:	00000793          	li	a5,0
800003e4:	00072683          	lw	a3,0(a4)
800003e8:	00178793          	addi	a5,a5,1
800003ec:	00470713          	addi	a4,a4,4
800003f0:	00d50533          	add	a0,a0,a3
800003f4:	fe87c8e3          	blt	a5,s0,800003e4 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x12c>
800003f8:	00040593          	mv	a1,s0
800003fc:	4d8000ef          	jal	800008d4 <__divsi3>
80000400:	03c00793          	li	a5,60
80000404:	00050713          	mv	a4,a0
80000408:	18a7cc63          	blt	a5,a0,800005a0 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x2e8>
8000040c:	01e00793          	li	a5,30
80000410:	18f74463          	blt	a4,a5,80000598 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x2e0>
80000414:	04410a13          	addi	s4,sp,68
80000418:	000a0793          	mv	a5,s4
8000041c:	0007a023          	sw	zero,0(a5)
80000420:	08010693          	addi	a3,sp,128
80000424:	00478793          	addi	a5,a5,4
80000428:	fef69ae3          	bne	a3,a5,8000041c <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x164>
8000042c:	02c10593          	addi	a1,sp,44
80000430:	00040693          	mv	a3,s0
80000434:	00048613          	mv	a2,s1
80000438:	04410513          	addi	a0,sp,68
8000043c:	bf5ff0ef          	jal	80000030 <_Z28maxim_peaks_above_min_heightPlS_S_ll>
80000440:	02c10593          	addi	a1,sp,44
80000444:	00048613          	mv	a2,s1
80000448:	04410513          	addi	a0,sp,68
8000044c:	00400693          	li	a3,4
80000450:	d39ff0ef          	jal	80000188 <_Z24maxim_remove_close_peaksPlS_S_l>
80000454:	02c12983          	lw	s3,44(sp)
80000458:	00f00793          	li	a5,15
8000045c:	00098b13          	mv	s6,s3
80000460:	1337c463          	blt	a5,s3,80000588 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x2d0>
80000464:	00100713          	li	a4,1
80000468:	05375c63          	bge	a4,s3,800004c0 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x208>
8000046c:	04412603          	lw	a2,68(sp)
80000470:	04810693          	addi	a3,sp,72
80000474:	00000593          	li	a1,0
80000478:	00000513          	li	a0,0
8000047c:	00700813          	li	a6,7
80000480:	00060793          	mv	a5,a2
80000484:	0006a603          	lw	a2,0(a3)
80000488:	00170713          	addi	a4,a4,1
8000048c:	00468693          	addi	a3,a3,4
80000490:	40f607b3          	sub	a5,a2,a5
80000494:	00f85663          	bge	a6,a5,800004a0 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x1e8>
80000498:	00f50533          	add	a0,a0,a5
8000049c:	00158593          	addi	a1,a1,1
800004a0:	ff6740e3          	blt	a4,s6,80000480 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x1c8>
800004a4:	00058e63          	beqz	a1,800004c0 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x208>
800004a8:	42c000ef          	jal	800008d4 <__divsi3>
800004ac:	00050593          	mv	a1,a0
800004b0:	5dc00513          	li	a0,1500
800004b4:	420000ef          	jal	800008d4 <__divsi3>
800004b8:	00100793          	li	a5,1
800004bc:	00c0006f          	j	800004c8 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x210>
800004c0:	c1900513          	li	a0,-999
800004c4:	00000793          	li	a5,0
800004c8:	00ac2023          	sw	a0,0(s8)
800004cc:	00fa8023          	sb	a5,0(s5)
800004d0:	19048a93          	addi	s5,s1,400
800004d4:	000b8793          	mv	a5,s7
800004d8:	000a8613          	mv	a2,s5
800004dc:	00048693          	mv	a3,s1
800004e0:	00000713          	li	a4,0
800004e4:	00095503          	lhu	a0,0(s2)
800004e8:	0007d583          	lhu	a1,0(a5)
800004ec:	00170713          	addi	a4,a4,1
800004f0:	00a6a023          	sw	a0,0(a3)
800004f4:	00b62023          	sw	a1,0(a2)
800004f8:	00290913          	addi	s2,s2,2
800004fc:	00468693          	addi	a3,a3,4
80000500:	00278793          	addi	a5,a5,2
80000504:	00460613          	addi	a2,a2,4
80000508:	fc874ee3          	blt	a4,s0,800004e4 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x22c>
8000050c:	02012823          	sw	zero,48(sp)
80000510:	02012a23          	sw	zero,52(sp)
80000514:	02012c23          	sw	zero,56(sp)
80000518:	02012e23          	sw	zero,60(sp)
8000051c:	04012023          	sw	zero,64(sp)
80000520:	35305263          	blez	s3,80000864 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x5ac>
80000524:	04410793          	addi	a5,sp,68
80000528:	00000713          	li	a4,0
8000052c:	0080006f          	j	80000534 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x27c>
80000530:	09675463          	bge	a4,s6,800005b8 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x300>
80000534:	0007a683          	lw	a3,0(a5)
80000538:	00170713          	addi	a4,a4,1
8000053c:	00478793          	addi	a5,a5,4
80000540:	fe86c8e3          	blt	a3,s0,80000530 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x278>
80000544:	c1900793          	li	a5,-999
80000548:	00fda023          	sw	a5,0(s11)
8000054c:	01c12783          	lw	a5,28(sp)
80000550:	00078023          	sb	zero,0(a5)
80000554:	0b812403          	lw	s0,184(sp)
80000558:	0bc12083          	lw	ra,188(sp)
8000055c:	0b412483          	lw	s1,180(sp)
80000560:	0b012903          	lw	s2,176(sp)
80000564:	0ac12983          	lw	s3,172(sp)
80000568:	0a812a03          	lw	s4,168(sp)
8000056c:	0a412a83          	lw	s5,164(sp)
80000570:	0a012b03          	lw	s6,160(sp)
80000574:	09c12b83          	lw	s7,156(sp)
80000578:	09812c03          	lw	s8,152(sp)
8000057c:	08c12d83          	lw	s11,140(sp)
80000580:	0c010113          	addi	sp,sp,192
80000584:	00008067          	ret
80000588:	00100713          	li	a4,1
8000058c:	00078b13          	mv	s6,a5
80000590:	ed374ee3          	blt	a4,s3,8000046c <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x1b4>
80000594:	f2dff06f          	j	800004c0 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x208>
80000598:	00078713          	mv	a4,a5
8000059c:	e79ff06f          	j	80000414 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x15c>
800005a0:	00078713          	mv	a4,a5
800005a4:	01e00793          	li	a5,30
800005a8:	e6f756e3          	bge	a4,a5,80000414 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x15c>
800005ac:	fedff06f          	j	80000598 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x2e0>
800005b0:	00088413          	mv	s0,a7
800005b4:	d49ff06f          	j	800002fc <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x44>
800005b8:	00100793          	li	a5,1
800005bc:	2af98463          	beq	s3,a5,80000864 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x5ac>
800005c0:	09912a23          	sw	s9,148(sp)
800005c4:	09a12823          	sw	s10,144(sp)
800005c8:	fffb0b13          	addi	s6,s6,-1
800005cc:	00000913          	li	s2,0
800005d0:	00000c93          	li	s9,0
800005d4:	00000993          	li	s3,0
800005d8:	00000b93          	li	s7,0
800005dc:	00300d13          	li	s10,3
800005e0:	00c0006f          	j	800005ec <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x334>
800005e4:	004a0a13          	addi	s4,s4,4
800005e8:	196bd463          	bge	s7,s6,80000770 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x4b8>
800005ec:	004a2583          	lw	a1,4(s4)
800005f0:	000a2803          	lw	a6,0(s4)
800005f4:	001b8b93          	addi	s7,s7,1
800005f8:	41058c33          	sub	s8,a1,a6
800005fc:	ff8d54e3          	bge	s10,s8,800005e4 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x32c>
80000600:	fff84793          	not	a5,a6
80000604:	41f7d793          	srai	a5,a5,0x1f
80000608:	00f877b3          	and	a5,a6,a5
8000060c:	00058513          	mv	a0,a1
80000610:	00b45463          	bge	s0,a1,80000618 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x360>
80000614:	00040513          	mv	a0,s0
80000618:	24a7d063          	bge	a5,a0,80000858 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x5a0>
8000061c:	00279713          	slli	a4,a5,0x2
80000620:	800008b7          	lui	a7,0x80000
80000624:	00e486b3          	add	a3,s1,a4
80000628:	00088313          	mv	t1,a7
8000062c:	01570733          	add	a4,a4,s5
80000630:	0006a603          	lw	a2,0(a3)
80000634:	00468693          	addi	a3,a3,4
80000638:	00c8d663          	bge	a7,a2,80000644 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x38c>
8000063c:	00060893          	mv	a7,a2
80000640:	00078913          	mv	s2,a5
80000644:	00072603          	lw	a2,0(a4)
80000648:	00470713          	addi	a4,a4,4
8000064c:	00c35663          	bge	t1,a2,80000658 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x3a0>
80000650:	00060313          	mv	t1,a2
80000654:	00078c93          	mv	s9,a5
80000658:	00178793          	addi	a5,a5,1
8000065c:	fcf51ae3          	bne	a0,a5,80000630 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x378>
80000660:	00281713          	slli	a4,a6,0x2
80000664:	00259593          	slli	a1,a1,0x2
80000668:	00b487b3          	add	a5,s1,a1
8000066c:	00e48733          	add	a4,s1,a4
80000670:	19072683          	lw	a3,400(a4)
80000674:	1907a503          	lw	a0,400(a5)
80000678:	410c85b3          	sub	a1,s9,a6
8000067c:	01112c23          	sw	a7,24(sp)
80000680:	40d50533          	sub	a0,a0,a3
80000684:	00612a23          	sw	t1,20(sp)
80000688:	00f12823          	sw	a5,16(sp)
8000068c:	00e12623          	sw	a4,12(sp)
80000690:	01012423          	sw	a6,8(sp)
80000694:	00d12223          	sw	a3,4(sp)
80000698:	218000ef          	jal	800008b0 <__mulsi3>
8000069c:	000c0593          	mv	a1,s8
800006a0:	234000ef          	jal	800008d4 <__divsi3>
800006a4:	00c12703          	lw	a4,12(sp)
800006a8:	01012783          	lw	a5,16(sp)
800006ac:	00812803          	lw	a6,8(sp)
800006b0:	00072703          	lw	a4,0(a4)
800006b4:	0007a783          	lw	a5,0(a5)
800006b8:	00412683          	lw	a3,4(sp)
800006bc:	410905b3          	sub	a1,s2,a6
800006c0:	00e12223          	sw	a4,4(sp)
800006c4:	00a686b3          	add	a3,a3,a0
800006c8:	40e78533          	sub	a0,a5,a4
800006cc:	00d12423          	sw	a3,8(sp)
800006d0:	1e0000ef          	jal	800008b0 <__mulsi3>
800006d4:	000c0593          	mv	a1,s8
800006d8:	1fc000ef          	jal	800008d4 <__divsi3>
800006dc:	002c9793          	slli	a5,s9,0x2
800006e0:	00f487b3          	add	a5,s1,a5
800006e4:	00412703          	lw	a4,4(sp)
800006e8:	00812683          	lw	a3,8(sp)
800006ec:	1907a783          	lw	a5,400(a5)
800006f0:	01812583          	lw	a1,24(sp)
800006f4:	00a70c33          	add	s8,a4,a0
800006f8:	40d78533          	sub	a0,a5,a3
800006fc:	1b4000ef          	jal	800008b0 <__mulsi3>
80000700:	00291793          	slli	a5,s2,0x2
80000704:	00f487b3          	add	a5,s1,a5
80000708:	0007a703          	lw	a4,0(a5)
8000070c:	01412583          	lw	a1,20(sp)
80000710:	40755793          	srai	a5,a0,0x7
80000714:	41870533          	sub	a0,a4,s8
80000718:	00f12223          	sw	a5,4(sp)
8000071c:	194000ef          	jal	800008b0 <__mulsi3>
80000720:	00412783          	lw	a5,4(sp)
80000724:	40755593          	srai	a1,a0,0x7
80000728:	00b02733          	sgtz	a4,a1
8000072c:	00f036b3          	snez	a3,a5
80000730:	00d77733          	and	a4,a4,a3
80000734:	ea0708e3          	beqz	a4,800005e4 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x32c>
80000738:	0059a713          	slti	a4,s3,5
8000073c:	ea0704e3          	beqz	a4,800005e4 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x32c>
80000740:	00179513          	slli	a0,a5,0x1
80000744:	00f50533          	add	a0,a0,a5
80000748:	00351513          	slli	a0,a0,0x3
8000074c:	00f50533          	add	a0,a0,a5
80000750:	00299c13          	slli	s8,s3,0x2
80000754:	00251513          	slli	a0,a0,0x2
80000758:	01810c33          	add	s8,sp,s8
8000075c:	178000ef          	jal	800008d4 <__divsi3>
80000760:	02ac2823          	sw	a0,48(s8)
80000764:	00198993          	addi	s3,s3,1
80000768:	004a0a13          	addi	s4,s4,4
8000076c:	e96bc0e3          	blt	s7,s6,800005ec <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x334>
80000770:	00098593          	mv	a1,s3
80000774:	03010513          	addi	a0,sp,48
80000778:	961ff0ef          	jal	800000d8 <_Z17maxim_sort_ascendPll>
8000077c:	00300713          	li	a4,3
80000780:	4019d793          	srai	a5,s3,0x1
80000784:	0b375a63          	bge	a4,s3,80000838 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x580>
80000788:	00279713          	slli	a4,a5,0x2
8000078c:	00279793          	slli	a5,a5,0x2
80000790:	00e10733          	add	a4,sp,a4
80000794:	00f107b3          	add	a5,sp,a5
80000798:	0307a783          	lw	a5,48(a5)
8000079c:	02c72703          	lw	a4,44(a4)
800007a0:	00f70733          	add	a4,a4,a5
800007a4:	01f75793          	srli	a5,a4,0x1f
800007a8:	00e787b3          	add	a5,a5,a4
800007ac:	4017d793          	srai	a5,a5,0x1
800007b0:	ffd78713          	addi	a4,a5,-3
800007b4:	0b400693          	li	a3,180
800007b8:	08e6ea63          	bltu	a3,a4,8000084c <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x594>
800007bc:	80001737          	lui	a4,0x80001
800007c0:	98870713          	addi	a4,a4,-1656 # 80000988 <_ZL14uch_spo2_table>
800007c4:	00f707b3          	add	a5,a4,a5
800007c8:	0007c703          	lbu	a4,0(a5)
800007cc:	00100793          	li	a5,1
800007d0:	00eda023          	sw	a4,0(s11)
800007d4:	01c12703          	lw	a4,28(sp)
800007d8:	00f70023          	sb	a5,0(a4)
800007dc:	0b812403          	lw	s0,184(sp)
800007e0:	0bc12083          	lw	ra,188(sp)
800007e4:	0b412483          	lw	s1,180(sp)
800007e8:	0b012903          	lw	s2,176(sp)
800007ec:	0ac12983          	lw	s3,172(sp)
800007f0:	0a812a03          	lw	s4,168(sp)
800007f4:	0a412a83          	lw	s5,164(sp)
800007f8:	0a012b03          	lw	s6,160(sp)
800007fc:	09c12b83          	lw	s7,156(sp)
80000800:	09812c03          	lw	s8,152(sp)
80000804:	09412c83          	lw	s9,148(sp)
80000808:	09012d03          	lw	s10,144(sp)
8000080c:	08c12d83          	lw	s11,140(sp)
80000810:	0c010113          	addi	sp,sp,192
80000814:	00008067          	ret
80000818:	c1900613          	li	a2,-999
8000081c:	00c6a023          	sw	a2,0(a3)
80000820:	00070023          	sb	zero,0(a4)
80000824:	00c7a023          	sw	a2,0(a5)
80000828:	00080023          	sb	zero,0(a6)
8000082c:	0bc12083          	lw	ra,188(sp)
80000830:	0c010113          	addi	sp,sp,192
80000834:	00008067          	ret
80000838:	00098a63          	beqz	s3,8000084c <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x594>
8000083c:	00279793          	slli	a5,a5,0x2
80000840:	00f107b3          	add	a5,sp,a5
80000844:	0307a783          	lw	a5,48(a5)
80000848:	f69ff06f          	j	800007b0 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x4f8>
8000084c:	09412c83          	lw	s9,148(sp)
80000850:	09012d03          	lw	s10,144(sp)
80000854:	cf1ff06f          	j	80000544 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x28c>
80000858:	800008b7          	lui	a7,0x80000
8000085c:	00088313          	mv	t1,a7
80000860:	e01ff06f          	j	80000660 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x3a8>
80000864:	00000593          	li	a1,0
80000868:	03010513          	addi	a0,sp,48
8000086c:	86dff0ef          	jal	800000d8 <_Z17maxim_sort_ascendPll>
80000870:	cd5ff06f          	j	80000544 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_+0x28c>

80000874 <main>:
80000874:	80010637          	lui	a2,0x80010
80000878:	fe010113          	addi	sp,sp,-32
8000087c:	00060613          	mv	a2,a2
80000880:	0c860513          	addi	a0,a2,200 # 800100c8 <_ZL13pun_ir_buffer>
80000884:	00710813          	addi	a6,sp,7
80000888:	00c10793          	addi	a5,sp,12
8000088c:	00610713          	addi	a4,sp,6
80000890:	00810693          	addi	a3,sp,8
80000894:	06400593          	li	a1,100
80000898:	00112e23          	sw	ra,28(sp)
8000089c:	a1dff0ef          	jal	800002b8 <_Z38maxim_heart_rate_and_oxygen_saturationPtlS_PlPaS0_S1_>
800008a0:	01c12083          	lw	ra,28(sp)
800008a4:	00000513          	li	a0,0
800008a8:	02010113          	addi	sp,sp,32
800008ac:	00008067          	ret

800008b0 <__mulsi3>:
800008b0:	00050613          	mv	a2,a0
800008b4:	00000513          	li	a0,0
800008b8:	0015f693          	andi	a3,a1,1
800008bc:	00068463          	beqz	a3,800008c4 <__mulsi3+0x14>
800008c0:	00c50533          	add	a0,a0,a2
800008c4:	0015d593          	srli	a1,a1,0x1
800008c8:	00161613          	slli	a2,a2,0x1
800008cc:	fe0596e3          	bnez	a1,800008b8 <__mulsi3+0x8>
800008d0:	00008067          	ret

800008d4 <__divsi3>:
800008d4:	06054063          	bltz	a0,80000934 <__umodsi3+0x10>
800008d8:	0605c663          	bltz	a1,80000944 <__umodsi3+0x20>

800008dc <__hidden___udivsi3>:
800008dc:	00058613          	mv	a2,a1
800008e0:	00050593          	mv	a1,a0
800008e4:	fff00513          	li	a0,-1
800008e8:	02060c63          	beqz	a2,80000920 <__hidden___udivsi3+0x44>
800008ec:	00100693          	li	a3,1
800008f0:	00b67a63          	bgeu	a2,a1,80000904 <__hidden___udivsi3+0x28>
800008f4:	00c05863          	blez	a2,80000904 <__hidden___udivsi3+0x28>
800008f8:	00161613          	slli	a2,a2,0x1
800008fc:	00169693          	slli	a3,a3,0x1
80000900:	feb66ae3          	bltu	a2,a1,800008f4 <__hidden___udivsi3+0x18>
80000904:	00000513          	li	a0,0
80000908:	00c5e663          	bltu	a1,a2,80000914 <__hidden___udivsi3+0x38>
8000090c:	40c585b3          	sub	a1,a1,a2
80000910:	00d56533          	or	a0,a0,a3
80000914:	0016d693          	srli	a3,a3,0x1
80000918:	00165613          	srli	a2,a2,0x1
8000091c:	fe0696e3          	bnez	a3,80000908 <__hidden___udivsi3+0x2c>
80000920:	00008067          	ret

80000924 <__umodsi3>:
80000924:	00008293          	mv	t0,ra
80000928:	fb5ff0ef          	jal	800008dc <__hidden___udivsi3>
8000092c:	00058513          	mv	a0,a1
80000930:	00028067          	jr	t0
80000934:	40a00533          	neg	a0,a0
80000938:	00b04863          	bgtz	a1,80000948 <__umodsi3+0x24>
8000093c:	40b005b3          	neg	a1,a1
80000940:	f9dff06f          	j	800008dc <__hidden___udivsi3>
80000944:	40b005b3          	neg	a1,a1
80000948:	00008293          	mv	t0,ra
8000094c:	f91ff0ef          	jal	800008dc <__hidden___udivsi3>
80000950:	40a00533          	neg	a0,a0
80000954:	00028067          	jr	t0

80000958 <__modsi3>:
80000958:	00008293          	mv	t0,ra
8000095c:	0005ca63          	bltz	a1,80000970 <__modsi3+0x18>
80000960:	00054c63          	bltz	a0,80000978 <__modsi3+0x20>
80000964:	f79ff0ef          	jal	800008dc <__hidden___udivsi3>
80000968:	00058513          	mv	a0,a1
8000096c:	00028067          	jr	t0
80000970:	40b005b3          	neg	a1,a1
80000974:	fe0558e3          	bgez	a0,80000964 <__modsi3+0xc>
80000978:	40a00533          	neg	a0,a0
8000097c:	f61ff0ef          	jal	800008dc <__hidden___udivsi3>
80000980:	40b00533          	neg	a0,a1
80000984:	00028067          	jr	t0

80000988 <_ZL14uch_spo2_table>:
80000988:	605f5f5f 61616060 62616161 62626262     ___```aaaaabbbbb
80000998:	63636363 63636363 64646464 64646464     ccccccccdddddddd
800009a8:	64646464 64646464 64646464 63636363     ddddddddddddcccc
800009b8:	63636363 62626262 61616262 60606161     ccccbbbbbbaaaa``
800009c8:	5f5f6060 5e5e5e5f 5c5d5d5d 5b5b5c5c     ``___^^^]]]\\\[[
800009d8:	59595a5a 57585859 55565657 53545455     ZZYYYXXWWVVUUTTS
800009e8:	51515252 4e4f5050 4c4c4d4e 494a4a4b     RRQQPPONNMLLKJJI
800009f8:	46474848 43444545 40414242 3d3e3e3f     HHGFEEDCBBA@?>>=
80000a08:	393a3b3c 36373838 32333435 2e2f3031     <;:98876543210/.
80000a18:	2a2b2c2d 26272829 22232425 1d1e1f21     -,+*)('&%$#"!...
80000a28:	191a1b1c 14151617 0f101113 0a0b0c0e     ................
80000a38:	05060709 00010203                       ........
