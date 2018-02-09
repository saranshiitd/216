@Assembly program to generate happy numbers
	.equ SWI_Exit, 0x11
	.equ SWI_PrInt,0x6b @write an integer
	.equ SWI_Open, 0x66 @Open a file
	.text
ldr r3,=ZERO
ldr r4,=ONE

ldr r0,=OutFileName		@print contents at [r0]
mov r1,#1 @output mode
swi SWI_Open
ldr r1,=OutFileHandle
str r0,[r1]



@Main
ldr r1,=ONE
ldr r0,=X
bl copy_BCD
ldr r6,=S
ldr r7,=Y
mov r9,#1 @Initialize counter
Loop_outer:mov r8,#1 @Initialize counter
Loop_inner:
mov r1,r0 @Copy address of X in r1
mov r0,r7 @Copy address of Y in r0
stmdb sp!,{r14,r2} @Push link register contents into the stack
bl copy_BCD @r0 and r1 are unchanged
ldmia sp!,{r2,r14} @Pop it back
Loop02:
mov r0,r7 @Copy address of Y in r0
bl check_gt_1 
cmp r0,#0
beq Loop01_end
mov r0,r6
mov r1,r7
stmdb sp!,{r14,r6,r7} @Push link register contents into the stack, along with r6 (as it will be required by sum_square)
bl sum_square
ldmia sp!,{r7,r6,r14} @Pop it back
ldr r3,[r0] @To display output of sum square in r3
mov r0,r7
mov r1,r6
stmdb sp!,{r14,r2} @Push link register contents into the stack
bl copy_BCD
ldmia sp!,{r2,r14} @Pop it back
b Loop02
Loop01_end:
ldrb r0,[r7] @Copy Y[0] in r0
stmdb sp!,{r14} @Push link register contents into the stack
bl check_happy
ldmia sp!,{r14} @Pop it back
cmp r0,#0
beq ahead @if not happy, skip the next statements
ldr r0,=OutFileHandle	@print contents at [r0]
ldr r0,[r0]
ldr r2,=X
mov r10,#3
PrintLoop:
ldrb r1,[r2,r10]
swi SWI_PrInt
sub r10,r10,#1
cmp r10,#-1
bne PrintLoop
ldr r1,=EndOfLine
swi 0x69
ahead:
stmdb sp!,{r14,r6,r7} @Push link register contents into the stack
ldr r0,=X
ldr r1,=X
ldr r2,=ONE
bl add_BCD
ldmia sp!,{r7,r6,r14} @Pop it back
ldr r1,[r0]
ldr r3,[r2]
add r8,r8,#1
cmp r8,#100
bne Loop_inner
add r9,r9,#1
cmp r9,#102
bne Loop_outer
swi SWI_Exit
 





copy_BCD: 		@copies values starting at mem address stored in r1 to mem addresses starting with r0 {requires r0*,r1*,r2}
ldr r2,[r1] 	 
str r2,[r0]
mov pc, lr @go to instruction stored in lr, r0 and r1 are unchanged

square_digit:	@accepts address stored in r0, digit stored in r1 {requires r0*,r1,r2,r3}
	stmdb sp!,{r1}
	ldr r1,=ZERO
	stmdb sp!,{r14,r2} @Push link register contents into the stack
	bl copy_BCD
	ldmia sp!,{r2,r14} @Pop it back
	ldmia sp!,{r1}
	mul r2,r1,r1
	strb r2,[r0]
Loop21:	ldrb r2,[r0]
	cmp r2,#9
	ble Loop22
	ldrb r3, [r0]
	sub r3,r3,#10
	strb r3,[r0]	@ [r0]=[r0]-10
	ldrb r3,[r0,#1]	
	add r3,r3,#1
	strb r3,[r0,#1] @[r0+1]=[r0+1]+1
	b Loop21
Loop22:	mov pc,lr
	

add_BCD:
	mov r7,#0 
	mov r3,#0
	ldrb r4,[r0]
	ldrb r5,[r1]
	ldrb r6,[r2]
	add r4,r5,r6
	add r4,r4,r3
	strb r4,[r0]
	cmp r4,#9
	ble halt1
	sub r4,r4,#10
	strb r4,[r0]
	mov r3,#1
halt1:  @{r0*,r1*,r2*,going to need 4 more register temporarily}
	add r7,r7,#1	
	ldrb r4,[r0,r7]
	ldrb r5,[r1,r7]
	ldrb r6,[r2,r7]
	add r4,r5,r6
	add r4,r4,r3
	strb r4,[r0,r7]	
	mov r3,#0
	cmp r7,#3
	beq funcend
	cmp r4,#9
	ble halt1
	sub r4,r4,#10
	strb r4,[r0,r7]
	
	mov r3,#1
	b halt1
funcend:
	mov pc,lr

sum_square:
	mov r12,#0 			@r0 s,r1 x
	@ldr r5,[r1]
	@str r5,[r2]
	mov r2,r1		@x is loaded at r2
	ldr r1,=ZERO		@r1 ZERO
	stmdb r13!,{r14,r2}	
	bl copy_BCD		@in r0, now 0
	ldmia r13!,{r2,r14}
	@ldr r5,[r0]
	@str r5,[r3]
	mov r3,r0		@now r3 0
	ldr r0,=EMPTY		@ given empty space to r0
	ldr r11,[r2]
	ldr r5,[r2]
	ldr r4,=SPACE4
	str r5,[r4]
	@mov r4,r2		@x loaded in r4
	ldr r1,=FREE_SPACE	@r1 given free space
	ldr r11,[r4]
LPoint:	ldrb r1,[r4]		@first digit loaded in r1
	ldrb r11,[r4]
	stmdb r13!,{r14,r2,r3}	
	bl square_digit		@here r0 is empty r1 is first digit
	ldr r11,[r0]
	ldmia r13!,{r3,r2,r14}
	ldr r11,[r3]
	ldr r5,[r0]
	str r5,[r2]
	@mov r2,r0		@answer stored in r2
	ldr r5,[r3]
	str r5,[r0]
	mov r1,r0
	@str r5,[r1]
	@mov r0,r3		@value retreival from r3	
	@mov r1,r3		@value retreival from r3
	stmdb r13!,{r14,r3,r4,r5}
	bl add_BCD		
	ldr r11,[r0]
	ldmia r13!,{r5,r4,r3,r14}
	add r4,r4,#1		@in r0 is answer
	add r12,r12,#1
	ldr r5,[r0]
	str r5,[r3]
	ldr r11,[r3]	
	cmp r12,#4
	bne LPoint	
	mov pc,lr

check_gt_1:
	@add r0,r0,#1
	ldrb r1,[r0,#1]
	cmp r1,#0
	bne endl
	ldrb r1,[r0,#2]
	cmp r1,#0
	bne endl
	ldrb r1,[r0,#3]
	cmp r1,#0
	bne endl
	mov r0,#0
	mov pc,lr
endl:mov r0,#1
	mov pc,lr

check_happy:
	cmp r0,#1
	bne happy_branch
	mov r0,#1
	mov pc,lr
happy_branch:
	cmp r0,#7
	bne happy_end
	mov r0,#1
	mov pc,lr
happy_end:
	mov r0,#0
	mov pc,lr




.data
OutFileHandle: .word 0
OutFileName: .asciz "out.txt"
EndOfLine: .asciz "\n" 
ZERO:	.word 0,0,0,0
ONE: .word 1,0,0,0
EMPTY: .space 4
FREE_SPACE: .space 4
SPACE4: .space 4
X: .space 4
S: .space 4
Y: .space 4
.end
	    
	

