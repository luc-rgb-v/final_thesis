.section .text
.globl _start
_start:
li x1,0
li x2,5
li x3,5
li x4,10
li x5,0 #status(0=PASS)
li x6,0
li x7,0
li x8,0
add x6,x2,x3 #10
sub x7,x4,x2 #5
xor x8,x2,x4
xor x8,x8,x7
add x1,x6,x3 #15
beq x2,x3,BEQ_OK
li x5,1 #FAIL
BEQ_OK:
addi x6,x6,1 #11
or x8,x8,x4
and x7,x7,x4 #0
xor x1,x1,x6
add x3,x3,x0
bne x2,x3,BNE_FAIL
j BNE_OK
BNE_FAIL:
li x5,2 #FAIL
BNE_OK:
or x6,x6,x7
add x1,x1,x6
sll x8,x8,x2
xor x1,x1,x8
blt x2,x4,BLT_OK
li x5,3 #FAIL
BLT_OK:
addi x7,x7,-2 #-2
xor x8,x8,x7
srl x6,x6,x3
add x1,x1,x6
bge x4,x2,BGE_OK
li x5,4 #FAIL
BGE_OK:
li x9,-1
li x10,1
xor x1,x1,x9
add x11,x9,x10
bltu x10,x9,BLTU_OK
li x5,5 #FAIL
BLTU_OK:
xor x1,x1,x10
bgeu x9,x10,BGEU_OK
li x5,6 #FAIL
BGEU_OK:
jal ra,JAL_TARGET
JAL_RETURN:
addi x6,x6,4
xor x8,x8,x6
add x1,x1,x6
la x12,JALR_TARGET
jalr ra,0(x12)
JALR_RETURN:
li x13,4
add x1,x1,x13
LOOP:
add x6,x6,x13
add x8,x8,x6
addi x13,x13,-1
xor x1,x1,x13
bne x13,x0,LOOP
add x7,x6,x0
add x1,x1,x7
beq x7,x6,END_OK
li x5,9 #FAIL
END_OK:
li x5,0 #PASS
j END
JAL_TARGET:
addi x6,x6,1
add x1,x1,x6
jr ra
JALR_TARGET:
addi x31,x31,1
add x1,x1,x31
jr ra
END:
nop
