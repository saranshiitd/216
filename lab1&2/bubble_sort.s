@Assembly program to sort numbers using bubble sort
	.equ SWI_Exit, 0x11
	.text
	ldr r3, =AA 
	mov r1, #51
	str r1, [r3]  @Initialization (5 numbers)
	add r3, r3, #4 
	mov r1, #12
	str r1, [r3]
	add r3, r3, #4
	mov r1, #23
	str r1, [r3]
	add r3, r3, #4
	mov r1, #3
	str r1, [r3]
	add r3, r3, #4
	mov r1, #34
	str r1, [r3]
	add r3, r3, #4
	mov r1, #6 @Counter for outer loop 
Loop1:
	ldr r3, =AA  @Reset pointer
	sub r1, r1, #1
	cmp r1, #0
	ble finish
	mov r2, #1 @Counter for second loop
	Loop2:
		cmp r2,r1
		bge Loop1 @if r2>=r1, goto Loop1
		ldr r4, [r3]
		ldr r5, [r3, #4]
		cmp r4,r5
		ble swap 	@if less, don't swap
		str r4, [r3, #4]
		str r5, [r3]
		swap:
		add r2, r2, #1 @ increment counter
		add r3, r3, #4 @ increment memory address
		b Loop2 @repeat		
finish:
ldr r3, =AA
ldr r1, [r3]          @Load numbers into registers for display
ldr r2, [r3, #4]
ldr r4, [r3, #8]
ldr r5, [r3, #12]
ldr r6, [r3, #16]
mov r0, #51
swi     0x02
	
swi SWI_Exit
.data
AA:	.space 20
	.end
