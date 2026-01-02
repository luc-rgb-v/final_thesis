
build/main.elf:     file format elf32-littleriscv


Disassembly of section .text:

80000000 <main>:
80000000:	fe010113          	addi	sp,sp,-32
80000004:	00112e23          	sw	ra,28(sp)
80000008:	00812c23          	sw	s0,24(sp)
8000000c:	02010413          	addi	s0,sp,32
80000010:	00500793          	li	a5,5
80000014:	fef42623          	sw	a5,-20(s0)
80000018:	00700793          	li	a5,7
8000001c:	fef42423          	sw	a5,-24(s0)
80000020:	fec42703          	lw	a4,-20(s0)
80000024:	fe842783          	lw	a5,-24(s0)
80000028:	00f707b3          	add	a5,a4,a5
8000002c:	fef42223          	sw	a5,-28(s0)
80000030:	800007b7          	lui	a5,0x80000
80000034:	0447a783          	lw	a5,68(a5) # 80000044 <dmem>
80000038:	fe442703          	lw	a4,-28(s0)
8000003c:	00e7a023          	sw	a4,0(a5)
80000040:	0000006f          	j	80000040 <main+0x40>
