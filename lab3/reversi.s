	.equ SWI_Exit, 0x11
	.equ SWI_PrInt,0x6b @write an integer
	.equ SWI_Open, 0x66 @Open a file
	.equ SWI_DRAW_STRING, 0x204        @display a string on LCD
	.equ SWI_DRAW_INT,    0x205        @display an int on LCD
	.equ SWI_CLEAR_DISPLAY,0x206        @clear LCD
	.equ SWI_DRAW_CHAR,   0x207        @display a char on LCD
	.equ SWI_Board_Input, 0x203
	.equ SWI_Light_Bulb, 0x201
	.text
	

ldr r0,=int_to_char
mov r1,#79
strb r1,[r0,#0]
mov r1,#88
strb r1,[r0,#1]
mov r1,#45
strb r1,[r0,#2]
        
ldr r0,=OutFileName		@print contents at [r0]
mov r1,#1 @output mode
swi SWI_Open
ldr r1,=OutFileHandle
str r0,[r1]

@Player initialization: 

ldr r0,=PLAYER
mov r1,#0 @Player 0 begins the game
strb r1,[r0]
mov r0, #0x02
swi SWI_Light_Bulb

@Board initialization
mov r0,#0 @initialize counter
ldr r2,=BOARD
ldr r4,=BOARD @debugging
LoopIn:
mov r3,#2 @for empty square
strb r3,[r2] @column 0
add r2,r2,#1
strb r3, [r2]@column 1
add r2,r2,#1
strb r3, [r2]@column 2
 
mov r3,#2 @for empty square
add r2,r2,#1 @column 3 (conditional)
cmp r0,#3
moveq r3,#0 @for player 0 piece
cmp r0,#4
moveq r3,#1 @for player 1 piece
strb r3, [r2] 

mov r3,#2 @for empty square
add r2,r2,#1 @column 4 (conditional)
cmp r0,#3
moveq r3,#1 @for player 1 piece
cmp r0,#4
moveq r3,#0 @for player 0 piece
strb r3, [r2] 

mov r3,#2 @for empty square
add r2,r2,#1
strb r3,[r2] @column 5
add r2,r2,#1
strb r3, [r2]@column 6
add r2,r2,#1
strb r3, [r2]@column 7


add r2,r2,#1
add r0,r0,#1
cmp r0,#8
bne LoopIn

stmdb sp!,{r0,r1,r2,r3,r14}
bl DISP
ldmia sp!,{r14,r3,r2,r1,r0} 

mov r0 , # 30 
mov r1 , # 0 
ldr r2 , =Score_String
swi SWI_DRAW_STRING

getInput:  @ getting row number here

@stmdb sp!,{r14,r6,r5,r4,r3,r2,r1,r0}
@bl PASS
@cmp r3 , #0 
@bne input_process
@ldr r4,=PLAYER
@ldr r5,=INVERT
@ldrb r6,[r4]
@ldrb r6,[r5,r6]
@strb r6,[r4]
@mov r4,r0
@cmp r6,#0
@moveq r0,#0x02
@movne r0,#0x01
@swi SWI_Light_Bulb
@mov r0,r4
@ldmia sp! , {r0,r1,r2,r3,r4,r5,r6,r14}
stmdb sp! , {r14}
bl PASS
cmp r3 ,#0
ldmia sp! , {r14}
beq change_player
mov r0,#0
swi SWI_Board_Input 
cmp r0,#0
beq getInput
cmp r0, #1
moveq r1, #0
beq getColumn
cmp r0, #2
moveq r1, #1
beq getColumn
cmp r0, #4
moveq r1, #2
beq getColumn
cmp r0, #8
moveq r1, #3
beq getColumn
cmp r0, #16
moveq r1, #4
beq getColumn
cmp r0, #32
moveq r1, #5
beq getColumn
cmp r0, #64
moveq r1, #6
beq getColumn
cmp r0, #128
moveq r1, #7
beq getColumn
@ cmp r0, 256
@ cmp r0, 512
getColumn: @ getting column number here with row number stored in r1
@mov r3 , r1 
@mov r0 , #25
@mov r1 , #6 
@mov r2 , #88 
@swi SWI_DRAW_CHAR
@mov r0 , #27 
@mov r2 ,r3 
@swi SWI_DRAW_INT 
@mov r1 ,r3 
mov r0,#0
mov r3,#0
swi SWI_Board_Input 
cmp r0,#0
beq getColumn
cmp r0, #1
bne checkIn2
mov r2, #0
mov r0,r1
mov r1,r2
stmdb sp! , {r0,r1,r2,r3,r14}
bl updateBoard
cmp r0,#1
ldmia sp!,{r14,r3,r2,r1,r0}
moveq r3,#1
checkIn2:
cmp r0, #2
bne checkIn4
mov r2, #1
mov r0,r1
mov r1,r2
stmdb sp! , {r0,r1,r2,r3,r14}
bl updateBoard
cmp r0,#1
ldmia sp!,{r14,r3,r2,r1,r0}
moveq r3,#1
checkIn4:
cmp r0, #4
bne checkIn8
mov r2, #2
mov r0,r1
mov r1,r2
stmdb sp! , {r0,r1,r2,r3,r14}
bl updateBoard
cmp r0,#1
ldmia sp!,{r14,r3,r2,r1,r0}
moveq r3,#1
checkIn8:
cmp r0, #8
bne checkIn16
mov r2, #3
mov r0,r1
mov r1,r2
stmdb sp! , {r0,r1,r2,r3,r14}
bl updateBoard
cmp r0,#1
ldmia sp!,{r14,r3,r2,r1,r0}
moveq r3,#1
checkIn16:
cmp r0, #16
bne checkIn32
mov r2, #4
mov r0,r1
mov r1,r2
stmdb sp! , {r0,r1,r2,r3,r14}
bl updateBoard
cmp r0,#1
ldmia sp!,{r14,r3,r2,r1,r0}
moveq r3,#1
checkIn32:
cmp r0, #32
bne checkIn64
mov r2, #5
mov r0,r1
mov r1,r2
stmdb sp! , {r0,r1,r2,r3,r14}
bleq updateBoard
cmp r0,#1
ldmia sp!,{r14,r3,r2,r1,r0}
moveq r3,#1
checkIn64:
cmp r0, #64
bne checkIn128
moveq r2, #6
moveq r0,r1
moveq r1,r2
stmdb sp! , {r0,r1,r2,r3,r14}
bleq updateBoard
cmp r0,#1
ldmia sp!,{r14,r3,r2,r1,r0}
moveq r3,#1
checkIn128:
cmp r0, #128
bne endGetColumn
mov r2, #7
mov r0,r1
mov r1,r2
stmdb sp! , {r0,r1,r2,r3,r14}
bl updateBoard
cmp r0,#1
ldmia sp!,{r14,r3,r2,r1,r0}
moveq r3,#1
endGetColumn:
cmp r3,#1
bne is_invalid
@Player state change
change_player:
ldr r4,=PLAYER
ldr r5,=INVERT
ldrb r6,[r4]
ldrb r6,[r5,r6]
strb r6,[r4]
mov r4,r0
cmp r6,#0
moveq r0,#0x02
movne r0,#0x01
swi SWI_Light_Bulb
mov r0,r4
stmdb sp! , {r14,r6,r5,r4,r3,r2,r1,r0}
mov r0,#30
mov r1,#10
ldr r2,=Remove_Invalid
swi 0x204 
ldmia sp! , {r0,r1,r2,r3,r4,r5,r6,r14}
stmdb sp! , {r14,r6,r5,r4,r3,r2,r1,r0}
bl SCORE

mov r0 , #30
mov r1 , #1 
mov r2 , #79
swi SWI_DRAW_CHAR
mov r0 , #32 
mov r2 ,r3 
swi SWI_DRAW_INT  
mov r0 , #30
mov r1 , #2 
mov r2 , #88 
swi SWI_DRAW_CHAR
mov r0 , #32 
mov r2 ,r4 
swi SWI_DRAW_INT  


ldmia sp! , {r0,r1,r2,r3,r4,r5,r6,r14}
b on_completion_of_loop
is_invalid:
stmdb sp! , {r14,r6,r5,r4,r3,r2,r1,r0}
mov r0,#30
mov r1,#10
ldr r2,=Invalid_Message
swi 0x204 
ldmia sp! , {r0,r1,r2,r3,r4,r5,r6,r14}
b on_completion_of_loop
on_completion_of_loop:
b getInput

updateBoard: @ for updating board with row number in r0 column number in r1 returns 1 if some direction is changed otherwise 0


mov r3 , r0 
mov r4 , r1
mov r0 , #30
mov r1 , #6 
ldr r2 ,=row_string 
swi SWI_DRAW_STRING
mov r0 , #34 
mov r2 ,r3
add r2,r2,#1 
swi SWI_DRAW_INT  
mov r0 , #30
mov r1 , #8 
ldr r2 ,=col_string 
swi SWI_DRAW_STRING
mov r0 , #34 
mov r2 ,r4 
add r2,r2,#1
swi SWI_DRAW_INT  
mov r1 , r4 
mov r0 , r3 



mov r2,#0
mov r3, #0
stmdb sp! , {r0,r1,r2,r14,r3}
bl WEST
cmp r0,#0
ldmia sp!,{r3,r14,r2,r1,r0}
beq toEAST
mov r3,#1
mov r2,#1 
stmdb sp! , {r0,r1,r2,r14,r3}
bl WEST 
ldmia sp!,{r3,r14,r2,r1,r0}
toEAST:
mov r2,#0
stmdb sp! , {r0,r1,r2,r14,r3}
bl EAST
cmp r0,#0
ldmia sp!,{r3,r14,r2,r1,r0}
beq toSOUTH
mov r2,#1 
mov r3,#1
stmdb sp!, {r0,r1,r2,r14,r3}
bl EAST
ldmia sp!,{r3,r14,r2,r1,r0}
toSOUTH:
mov r2,#0
stmdb sp! , {r0,r1,r2,r14,r3}
bl SOUTH
cmp r0,#0
ldmia sp!,{r3,r14,r2,r1,r0}
beq toNORTH
mov r2,#1 
mov r3,#1
stmdb sp! , {r0,r1,r2,r14,r3}
bl SOUTH
ldmia sp!,{r3,r14,r2,r1,r0}
toNORTH:
mov r2,#0
stmdb sp! , {r0,r1,r2,r14,r3}
bl NORTH
cmp r0,#0
ldmia sp!,{r3,r14,r2,r1,r0}
beq toNORTH_WEST
mov r2,#1
mov r3,#1 
stmdb sp! , {r0,r1,r2,r14,r3}
bl NORTH
ldmia sp!,{r3,r14,r2,r1,r0}
toNORTH_WEST:
mov r2,#0
stmdb sp! , {r0,r1,r2,r14,r3}
bl NORTH_WEST
cmp r0,#0
ldmia sp!,{r3,r14,r2,r1,r0}
beq toNORTH_EAST
mov r2,#1
mov r3,#1 
stmdb sp! , {r0,r1,r2,r14,r3}
bl NORTH_WEST
ldmia sp!,{r3,r14,r2,r1,r0}
toNORTH_EAST:
mov r2,#0
stmdb sp! , {r0,r1,r2,r14,r3}
bl NORTH_EAST
cmp r0,#0
ldmia sp!,{r3,r14,r2,r1,r0}
beq toSOUTH_WEST
mov r2,#1
mov r3,#1 
stmdb sp! , {r0,r1,r2,r14,r3}
bl NORTH_WEST
ldmia sp!,{r3,r14,r2,r1,r0}
toSOUTH_WEST:
mov r2,#0
stmdb sp! , {r0,r1,r2,r14,r3}
bl SOUTH_WEST
cmp r0,#0
ldmia sp!,{r3,r14,r2,r1,r0}
beq toSOUTH_EAST
mov r2,#1
mov r3,#1 
stmdb sp! , {r0,r1,r2,r14,r3}
bl SOUTH_WEST
ldmia sp!,{r3,r14,r2,r1,r0}
toSOUTH_EAST:
mov r2,#0
stmdb sp! , {r0,r1,r2,r14,r3}
bl SOUTH_EAST
cmp r0,#0
ldmia sp!,{r3,r14,r2,r1,r0}
beq toEND
mov r2,#1
mov r3,#1 
stmdb sp! , {r0,r1,r2,r14,r3}
bl SOUTH_EAST
ldmia sp!,{r3,r14,r2,r1,r0}
toEND:
cmp r3,#0
bne nonNullEnd
mov r0,#0 
mov pc,lr
nonNullEnd:
mov r0,#1
stmdb sp!,{r0,r1,r2,r3,r14}
bl DISP
ldmia sp!,{r14,r3,r2,r1,r0} 
mov pc,lr

@Testing for WEST
mov r0,#3
mov r1,#5
mov r2,#0
stmdb sp!,{r0,r1}
bl WEST
cmp r0,#1
moveq r2,#1
ldmia sp!,{r1,r0}
bleq WEST
bl DISP
swi SWI_Exit



@Testing for EAST
mov r0,#4
mov r1,#7
mov r2,#0
stmdb sp!,{r0,r1}
bl EAST
cmp r0,#1
moveq r2,#1
ldmia sp!,{r1,r0}
bleq EAST
bl DISP
swi SWI_Exit



@Testing for SOUTH
mov r0,#2
mov r1,#3
mov r2,#0
stmdb sp!,{r0,r1}
bl SOUTH
cmp r0,#1
moveq r2,#1
ldmia sp!,{r1,r0}
bleq SOUTH
bl DISP
swi SWI_Exit



@Testing for NORTH
mov r0,#5
mov r1,#4
mov r2,#0
stmdb sp!,{r0,r1}
bl NORTH
cmp r0,#1
moveq r2,#1
ldmia sp!,{r1,r0}
bleq NORTH
bl DISP
swi SWI_Exit

@display board {requires r0,r1,r2,r3,r4}
DISP:
mov r1,#3 @initialize counter for row
ldr r4,=int_to_char
ldr r3,=BOARD
Loop1_disp:
mov r0,#4 @initialize counter for column
Loop2_disp:
ldrb r2,[r3]
ldrb r2,[r4,r2]
swi      SWI_DRAW_CHAR       @ draw to the LCD screen
add r3,r3,#1
add r0,r0,#2
cmp r0,#20
bne Loop2_disp
add r1,r1,#1
cmp r1,#11
bne Loop1_disp
mov r0,#4
mov r1,#2
mov r2,#0
Loop3_disp: @For printing 1,2,... in columns
add r2,r2,#1
swi SWI_DRAW_INT
add r0,r0,#2
cmp r0,#20
bne Loop3_disp
mov r0,#2
mov r1,#3
mov r2,#0
Loop4_disp: @For printing 1,2.. in rows
add r2,r2,#1
swi SWI_DRAW_INT
add r1,r1,#1
cmp r1,#11
bne Loop4_disp
mov pc,lr

@Flip north {input in r0 (row index), r1 (column index) and r2 (0-only check for match, 1- check and change)}
@output in r0 (1-indicating match found, 0-otherwise) 
NORTH:
cmp r0,#0 @0th row, so can't have a match
beq NORTH_RF

ldr r3,=BOARD
ldr r5,=PLAYER
ldrb r5,[r5] @Load player state in r5
ldr r6,=INVERT
add r6,r6,r5
ldrb r6,[r6] @Other player (corresponding to invert dict in python code)

mov r8,#8
mul r4,r0,r8 
add r4,r4,r1
add r3,r3,r4 @setting pointer to board[x][y]

cmp r2,#1
streqb r5,[r3] @if r2==1, set current player's piece on the position (we have checked if it can be flipped)

sub r0,r0,#1 @x-1
sub r3,r3,#8 @setting pointer to board[x-1][y]

ldrb r7,[r3]
cmp r7,r6 @if board[x-1][y]!= opponent's piece
bne NORTH_RF 

sub r0,r0,#1 @x-2

NORTH_LOOP:
cmp r2,#1
streqb r5,[r3] @if r2==1, flip the piece 
cmp r0,#0
blt NORTH_RF
sub r3,r3,#8
ldrb r7,[r3]
cmp r7,r5 @if board[x-i][y]==player's piece
beq NORTH_RT
cmp r7,r6 @if board[x-i][y]!=opponent's piece
bne NORTH_RF

@cmp r2,#1
@streqb r6,[r3] @if r2==1, flip the piece 

sub r0,r0,#1
b NORTH_LOOP


NORTH_RF:
mov r0,#0 @return False
mov pc,lr

NORTH_RT:
mov r0,#1 @return True
mov pc,lr



@Flip south {input in r0 (row index), r1 (column index) and r2 (0-only check for match, 1- check and change)}
@output in r0 (1-indicating match found, 0-otherwise) 
SOUTH:
cmp r0,#7 @7th row, so can't have a match
beq SOUTH_RF

ldr r3,=BOARD
ldr r5,=PLAYER
ldrb r5,[r5] @Load player state in r5
ldr r6,=INVERT
add r6,r6,r5
ldrb r6,[r6] @Other player (corresponding to invert dict in python code)

mov r8,#8
mul r4,r0,r8 
add r4,r4,r1
add r3,r3,r4 @setting pointer to board[x][y]

cmp r2,#1
streqb r5,[r3] @if r2==1, set current player's piece on the position (we have checked if it can be flipped)

add r0,r0,#1 @x+1
add r3,r3,#8 @setting pointer to board[x+1][y]

ldrb r7,[r3]
cmp r7,r6 @if board[x+1][y]!= opponent's piece
bne SOUTH_RF 

add r0,r0,#1 @x+2

SOUTH_LOOP:
cmp r2,#1
streqb r5,[r3] @if r2==1, flip the piece 
cmp r0,#7
bgt SOUTH_RF
add r3,r3,#8
ldrb r7,[r3]
cmp r7,r5 @if board[x+i][y]==player's piece
beq SOUTH_RT
cmp r7,r6 @if board[x+i][y]!=opponent's piece
bne SOUTH_RF

@cmp r2,#1
@streqb r6,[r3] @if r2==1, flip the piece 

add r0,r0,#1
b SOUTH_LOOP


SOUTH_RF:
mov r0,#0 @return False
mov pc,lr

SOUTH_RT:
mov r0,#1 @return True
mov pc,lr


@Flip east {input in r0 (row index), r1 (column index) and r2 (0-only check for match, 1- check and change)}
@output in r0 (1-indicating match found, 0-otherwise) 
EAST:
cmp r1,#7 @7th col, so can't have a match
beq EAST_RF

ldr r3,=BOARD
ldr r5,=PLAYER
ldrb r5,[r5] @Load player state in r5
ldr r6,=INVERT
add r6,r6,r5
ldrb r6,[r6] @Other player (corresponding to invert dict in python code)

mov r8,#8
mul r4,r0,r8 
add r4,r4,r1
add r3,r3,r4 @setting pointer to board[x][y]

cmp r2,#1
streqb r5,[r3] @if r2==1, set current player's piece on the position (we have checked if it can be flipped)

add r1,r1,#1 @x+1
add r3,r3,#1 @setting pointer to board[x][y+1]

ldrb r7,[r3]
cmp r7,r6 @if board[x][y+1]!= opponent's piece
bne EAST_RF 

add r1,r1,#1 @y+2

EAST_LOOP:
cmp r2,#1
streqb r5,[r3] @if r2==1, flip the piece 
cmp r1,#7
bgt EAST_RF
add r3,r3,#1
ldrb r7,[r3]
cmp r7,r5 @if board[x][y+i]==player's piece
beq EAST_RT
cmp r7,r6 @if board[x][y+i]!=opponent's piece
bne EAST_RF

@cmp r2,#1
@streqb r6,[r3] @if r2==1, flip the piece 

add r1,r1,#1
b EAST_LOOP


EAST_RF:
mov r0,#0 @return False
mov pc,lr

EAST_RT:
mov r0,#1 @return True
mov pc,lr


@Flip west {input in r0 (row index), r1 (column index) and r2 (0-only check for match, 1- check and change)}
@output in r0 (1-indicating match found, 0-otherwise) 
WEST:
cmp r1,#0 @0th col, so can't have a match
beq WEST_RF

ldr r3,=BOARD
ldr r5,=PLAYER
ldrb r5,[r5] @Load player state in r5
ldr r6,=INVERT
add r6,r6,r5
ldrb r6,[r6] @Other player (corresponding to invert dict in python code)

mov r8,#8
mul r4,r0,r8 
add r4,r4,r1
add r3,r3,r4 @setting pointer to board[x][y]

cmp r2,#1
streqb r5,[r3] @if r2==1, set current player's piece on the position (we have checked if it can be flipped)

sub r1,r1,#1 @y-1
sub r3,r3,#1 @setting pointer to board[x][y-1]

ldrb r7,[r3]
cmp r7,r6 @if board[x][y-1]!= opponent's piece
bne WEST_RF 

sub r1,r1,#1 @y-2

WEST_LOOP:
cmp r2,#1
streqb r5,[r3] @if r2==1, flip the piece 
cmp r1,#0
blt WEST_RF
sub r3,r3,#1
ldrb r7,[r3]
cmp r7,r5 @if board[x][y-i]==player's piece
beq WEST_RT
cmp r7,r6 @if board[x][y-i]!=opponent's piece
bne WEST_RF

@cmp r2,#1
@streqb r6,[r3] @if r2==1, flip the piece 

sub r1,r1,#1
b WEST_LOOP


WEST_RF:
mov r0,#0 @return False
mov pc,lr

WEST_RT:
mov r0,#1 @return True
mov pc,lr



@Flip NORTH_WEST {input in r0 (row index), r1 (column index) and r2 (0-only check for match, 1- check and change)}
@output in r0 (1-indicating match found, 0-otherwise) 
NORTH_WEST:
cmp r0,#0 @0th row, so can't have a match
beq NORTH_WEST_RF
cmp r1,#0 @0th col, so can't have a match
beq NORTH_WEST_RF

ldr r3,=BOARD
ldr r5,=PLAYER
ldrb r5,[r5] @Load player state in r5
ldr r6,=INVERT
add r6,r6,r5
ldrb r6,[r6] @Other player (corresponding to invert dict in python code)

mov r8,#8
mul r4,r0,r8 
add r4,r4,r1
add r3,r3,r4 @setting pointer to board[x][y]

cmp r2,#1
streqb r5,[r3] @if r2==1, set current player's piece on the position (we have checked if it can be flipped)

sub r0,r0,#1 @x-1
sub r1,r1,#1 @y-1
sub r3,r3,#9 @setting pointer to board[x-1][y-1]

ldrb r7,[r3]
cmp r7,r6 @if board[x-1][y-1]!= opponent's piece
bne NORTH_WEST_RF 

sub r0,r0,#1 @x-2
sub r1,r1,#1 @y-2

NORTH_WEST_LOOP:
cmp r2,#1
streqb r5,[r3] @if r2==1, flip the piece 
cmp r0,#0
blt NORTH_WEST_RF
cmp r1,#0
blt NORTH_WEST_RF
sub r3,r3,#9
ldrb r7,[r3]
cmp r7,r5 @if board[x-i][y-i]==player's piece
beq NORTH_WEST_RT
cmp r7,r6 @if board[x-i][y-i]!=opponent's piece
bne NORTH_WEST_RF

@cmp r2,#1
@streqb r6,[r3] @if r2==1, flip the piece 

sub r0,r0,#1
sub r1,r1,#1
b NORTH_WEST_LOOP


NORTH_WEST_RF:
mov r0,#0 @return False
mov pc,lr

NORTH_WEST_RT:
mov r0,#1 @return True
mov pc,lr


@Flip NORTH_EAST {input in r0 (row index), r1 (column index) and r2 (0-only check for match, 1- check and change)}
@output in r0 (1-indicating match found, 0-otherwise) 
NORTH_EAST:
cmp r0,#0 @0th row, so can't have a match
beq NORTH_EAST_RF
cmp r1,#7 @7th col, so can't have a match
beq NORTH_EAST_RF

ldr r3,=BOARD
ldr r5,=PLAYER
ldrb r5,[r5] @Load player state in r5
ldr r6,=INVERT
add r6,r6,r5
ldrb r6,[r6] @Other player (corresponding to invert dict in python code)

mov r8,#8
mul r4,r0,r8 
add r4,r4,r1
add r3,r3,r4 @setting pointer to board[x][y]

cmp r2,#1
streqb r5,[r3] @if r2==1, set current player's piece on the position (we have checked if it can be flipped)

sub r0,r0,#1 @x-1
add r1,r1,#1 @y+1
sub r3,r3,#7 @setting pointer to board[x-1][y+1]

ldrb r7,[r3]
cmp r7,r6 @if board[x-1][y+1]!= opponent's piece
bne NORTH_EAST_RF 

sub r0,r0,#1 @x-2
sub r1,r1,#-1 @y+2

NORTH_EAST_LOOP:
cmp r2,#1
streqb r5,[r3] @if r2==1, flip the piece 
cmp r0,#0
blt NORTH_EAST_RF
cmp r1,#7
bgt NORTH_EAST_RF
sub r3,r3,#7
ldrb r7,[r3]
cmp r7,r5 @if board[x-i][y+i]==player's piece
beq NORTH_EAST_RT
cmp r7,r6 @if board[x-i][y+i]!=opponent's piece
bne NORTH_EAST_RF

@cmp r2,#1
@streqb r6,[r3] @if r2==1, flip the piece 

sub r0,r0,#1
sub r1,r1,#-1
b NORTH_EAST_LOOP


NORTH_EAST_RF:
mov r0,#0 @return False
mov pc,lr

NORTH_EAST_RT:
mov r0,#1 @return True
mov pc,lr


@Flip SOUTH_EAST {input in r0 (row index), r1 (column index) and r2 (0-only check for match, 1- check and change)}
@output in r0 (1-indicating match found, 0-otherwise) 
SOUTH_EAST:
cmp r0,#7 @7th row, so can't have a match
beq SOUTH_EAST_RF
cmp r1,#7 @7th col, so can't have a match
beq SOUTH_EAST_RF

ldr r3,=BOARD
ldr r5,=PLAYER
ldrb r5,[r5] @Load player state in r5
ldr r6,=INVERT
add r6,r6,r5
ldrb r6,[r6] @Other player (corresponding to invert dict in python code)

mov r8,#8
mul r4,r0,r8 
add r4,r4,r1
add r3,r3,r4 @setting pointer to board[x][y]

cmp r2,#1
streqb r5,[r3] @if r2==1, set current player's piece on the position (we have checked if it can be flipped)

sub r0,r0,#-1 @x+1
sub r1,r1,#-1 @y+1
sub r3,r3,#-9 @setting pointer to board[x-1][y+1]

ldrb r7,[r3]
cmp r7,r6 @if board[x+1][y+1]!= opponent's piece
bne SOUTH_EAST_RF 

sub r0,r0,#-1 @x+2
sub r1,r1,#-1 @y+2

SOUTH_EAST_LOOP:
cmp r2,#1
streqb r5,[r3] @if r2==1, flip the piece 
cmp r0,#7
bgt SOUTH_EAST_RF
cmp r1,#7
bgt SOUTH_EAST_RF
sub r3,r3,#-9
ldrb r7,[r3]
cmp r7,r5 @if board[x+i][y+i]==player's piece
beq SOUTH_EAST_RT
cmp r7,r6 @if board[x+i][y+i]!=opponent's piece
bne SOUTH_EAST_RF

@cmp r2,#1
@streqb r6,[r3] @if r2==1, flip the piece 

sub r0,r0,#-1
sub r1,r1,#-1
b SOUTH_EAST_LOOP


SOUTH_EAST_RF:
mov r0,#0 @return False
mov pc,lr

SOUTH_EAST_RT:
mov r0,#1 @return True
mov pc,lr



@Flip SOUTH_WEST {input in r0 (row index), r1 (column index) and r2 (0-only check for match, 1- check and change)}
@output in r0 (1-indicating match found, 0-otherwise) 
SOUTH_WEST:
cmp r0,#7 @7th row, so can't have a match
beq SOUTH_WEST_RF
cmp r1,#0 @7th col, so can't have a match
beq SOUTH_WEST_RF

ldr r3,=BOARD
ldr r5,=PLAYER
ldrb r5,[r5] @Load player state in r5
ldr r6,=INVERT
add r6,r6,r5
ldrb r6,[r6] @Other player (corresponding to invert dict in python code)

mov r8,#8
mul r4,r0,r8 
add r4,r4,r1
add r3,r3,r4 @setting pointer to board[x][y]

cmp r2,#1
streqb r5,[r3] @if r2==1, set current player's piece on the position (we have checked if it can be flipped)

sub r0,r0,#-1 @x+1
sub r1,r1,#1 @y+1
sub r3,r3,#-7 @setting pointer to board[x-1][y+1]

ldrb r7,[r3]
cmp r7,r6 @if board[x+1][y-1]!= opponent's piece
bne SOUTH_WEST_RF 

sub r0,r0,#-1 @x+2
sub r1,r1,#1 @y-2

SOUTH_WEST_LOOP:
cmp r2,#1
streqb r5,[r3] @if r2==1, flip the piece 
cmp r0,#7
bgt SOUTH_WEST_RF
cmp r1,#0
blt SOUTH_WEST_RF
sub r3,r3,#-7
ldrb r7,[r3]
cmp r7,r5 @if board[x+i][y-i]==player's piece
beq SOUTH_WEST_RT
cmp r7,r6 @if board[x+i][y-i]!=opponent's piece
bne SOUTH_WEST_RF

@cmp r2,#1
@streqb r6,[r3] @if r2==1, flip the piece 

sub r0,r0,#-1
sub r1,r1,#1
b SOUTH_WEST_LOOP


SOUTH_WEST_RF:
mov r0,#0 @return False
mov pc,lr

SOUTH_WEST_RT:
mov r0,#1 @return True
mov pc,lr





CHECK_VALID: @{r1-row, r2-col, returns r0=1 if valid move}
mov r0,r1
mov r1,r2
mov r2,#0

stmdb sp!,{r0,r1,r2}
stmdb sp!,{r14}
bl EAST
ldmia sp!,{r14}
cmp r0,#1
beq VALID_RT
ldmia sp!,{r2,r1,r0}

stmdb sp!,{r0,r1,r2}
stmdb sp!,{r14}
bl WEST
ldmia sp!,{r14}
cmp r0,#1
beq VALID_RT
ldmia sp!,{r2,r1,r0}


stmdb sp!,{r0,r1,r2}
stmdb sp!,{r14}
bl NORTH
ldmia sp!,{r14}
cmp r0,#1
beq VALID_RT
ldmia sp!,{r2,r1,r0}


stmdb sp!,{r0,r1,r2}
stmdb sp!,{r14}
bl SOUTH
ldmia sp!,{r14}
cmp r0,#1
beq VALID_RT
ldmia sp!,{r2,r1,r0}


stmdb sp!,{r0,r1,r2}
stmdb sp!,{r14}
bl SOUTH_EAST
ldmia sp!,{r14}
cmp r0,#1
beq VALID_RT
ldmia sp!,{r2,r1,r0}


stmdb sp!,{r0,r1,r2}
stmdb sp!,{r14}
bl SOUTH_WEST
ldmia sp!,{r14}
cmp r0,#1
beq VALID_RT
ldmia sp!,{r2,r1,r0}



stmdb sp!,{r0,r1,r2}
stmdb sp!,{r14}
bl NORTH_EAST
ldmia sp!,{r14}
cmp r0,#1
beq VALID_RT
ldmia sp!,{r2,r1,r0}


stmdb sp!,{r0,r1,r2}
stmdb sp!,{r14}
bl NORTH_WEST
ldmia sp!,{r14}
cmp r0,#1
beq VALID_RT
ldmia sp!,{r2,r1,r0}


mov r0,#0
mov pc,lr

VALID_RT:
ldmia sp!,{r2,r1,r0}
mov r0,#1
mov pc,lr




PASS: @check if valid move exists or not {returns 0 in r3 if no valid move, else returns 1}
mov r3,#1 @return value
mov r1,#0 @For row
PASS_LOOP1:
mov r2,#0 @For col
PASS_LOOP2:
stmdb sp!,{r0,r1,r2,r3}
stmdb sp!,{r14}
bl CHECK_VALID @r0=#1 if valid
ldmia sp!,{r14}
cmp r0,#1
ldmia sp!,{r3,r2,r1,r0}
beq PASS_RT
add r2,r2,#1
cmp r2,#8
blt PASS_LOOP2
add r1,r1,#1
cmp r1,#8
blt PASS_LOOP1
mov r3,#0
mov pc,lr
PASS_RT:
mov r3,#1
mov pc,lr



SCORE: @requires {r0,r1,r2,r3,r4,r5}, returns 0's score in r3 and 1's score in r4
ldr r0,=BOARD
add r5,r0,#63
mov r1,#0
mov r3,#0
mov r4,#0
SCORE_LOOP:
ldrb r2,[r0]
cmp r2,#0
addeq r3,r3,#1
cmp r2,#1
addeq r4,r4,#1
add r0,r0,#1
cmp r0,r5
ble SCORE_LOOP
mov pc,lr






.data
OutFileHandle: .word 0
OutFileName: .asciz "out.txt"
BOARD:	.space 65 @8x8 (+1) Board configuration (0-'O',1-'X',2-'-')
PLAYER: .space 1 @0-'O',1-'X'
INVERT: .word 1,0 @ 1,0
Invalid_Message: .asciz "Invalid Move\n"
Remove_Invalid: .asciz "            \n"
Score_String: .asciz "Score:\n"
row_string: .asciz "row\n"
col_string: .asciz "col\n"
int_to_char: .space 3
.end
