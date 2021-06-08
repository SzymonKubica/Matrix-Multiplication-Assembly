_main:
	push	{r4, r5, r6, r7, r8, r10, r11, lr} ; pushes registers onto the stack.
	add		r11, sp, #24 ; adjusting stack pointer (SP)
	sub		sp, sp, #72 ; adjusting stack pointer (SP)
	mov		r0, #0 ; initializing register r0 to hold a value 0.
	str		r0, [r11, #-28] 
	str		r0, [r11, #-32] ; variable result is initialised to 0 held in r0.
	ldr		r1, .matrixA ; address of matrixA is loaded into the register r1.
	add		r2, sp, #40 ; 
	mov		r3, r2
	ldm		r1, {r4, r5, r6, r7, r12, lr} ; matrixA is loaded onto {r4, ..., lr} starting from r1 in memory.
	stm		r3, {r4, r5, r6, r7, r12, lr} ; contents of matrixA held by {r4, ..., lr} are stored at r3 and onwards in memory.
	ldr		r1, .matrixB ; address of matrixB is loaded into the register r1.
	add		r3, sp, #16
	mov		r12, r3
	ldm		r1, {r4, r5, r6, r7, r8, lr} ; matrixB is loaded onto {r4, ..., lr} starting from r1 in memory.
	stm		r12, {r4, r5, r6, r7, r8, lr} ; contents of matrixB held by {r4, ..., lr} are stored at r12 and onwards in memory.
	mov		r1, #3 ; r1 := 3 (ROWS).
	mov		r12, #2 ; r12 := 2 (COLUMNS).
	str		r0, [sp, #12] ; The 0 held by r0 is stored at sp +12. 
	mov		r0, r2 ; The pointer to matrixA stored at r2 is moved to r0 to pass it to mult as the first argument.
	str		r1, [sp, #8] ; Stores the value of ROWS (3) at sp + 8.
	mov		r1, r3 ; The pointer to matrixB stored at r3 is moved to r1 to pass it as the second argument to mult.
	ldr		r2, [sp, #8] ; r2 := ROWS (3). Third argument to mult. 
	mov		r3, r12 ; r3 := COLUMNS (2). Fourth argument to mult.
	bl		mult(int*, int*, int, int) ; branch into the execution of mult.
	str		r0,[r11, #-32] ; result of mult is stored at r11 -32.
	ldr		r1,[r11, #-32] ; result of mult is loaded from r11 -32 to r1.
	ldr		r0, .result_message ; result message is loaded into r0.
	bl    printf ; branch into the execution of printf with r0 and r1 as arguments.
	ldr		r1, [sp, #12] ; 0 present at the start at sp +12 is loaded into r1.
	str		r0, [sp, #4]  ; stores the present value of r0; 
	mov		r0, r1 ; 0 containted in r1 is loaded into r0.
	sub		sp, r11, #24 ; stack pointer is adjusted.
	pop		{r4, r5, r6, r7, r8, r10, r11, lr} ; registers are popped from the stack.
	bx		lr ; program terminates.
.matrixA:
	.long.L__const.main.matrixA
.matrixB:
	.long.L__const.main.matrixB
.result_message:
	.long.L.str
mult(int*,int*,int,int):
	push	{r11, lr} ; pushing necessary registers onto the stack.
	mov		r11, sp
	sub		sp, sp, #32
	str		r0, [r11, #-4] ; stores the pointer to matrixA (r0) to r11 -4.
	str		r1, [r11, #-8] ; stores the pointer to matirxB (r1) to r11 -8.
	str		r2, [r11, #-12] ; stores the value of rows into r11 -12. 
	str		r3, [sp, #16] ; stores the value of columns into sp +16.
	mov		r0, #0 ; initialises r0 to 0.
	str		r0, [sp, #12] ; stores the value of r0 at sp + 12. sum := 0.
	str		r0,[sp, #8] ; iniktialises counter i := 0.
	b			.outer_for_loop
.outer_for_loop:
	ldr		r0, [sp, #8] ; loads the value of i counter into r0.
	ldr		r1, [r11, #-12] ; loads the value of rows into r1.
	cmp		r0, r1 ; compare i < rows.
	bge		.end_of_outer_for_loop
	b			.outer_for_loop_body
.outer_for_loop_body:
	mov		r0, #0 ; initialises r0 to 0.
	str		r0, [sp, #4] ; stores the value of r0 at sp + 4. j := 0.
	b			.middle_for_loop
.middle_for_loop:
	ldr r0, [sp, #4] ; loads the value of j into r0. r0 := j.
	ldr r1, [r11, #-12] ; loads value of rows into r1, r1 := rows.
	cmp r0, r1 ; compares j < rows.
	bge .end_of_middle_for_loop ; if j >= rows branch to the end of middle for loop.
	b		.middle_for_loop_body ; otherwise branch to the body.
.middle_for_loop_body:
	mov r0, #0 ; initialises r0 to 0.
	str r0, [sp] ; stores value of r0 at sp. k := 0.
	b		.inner_for_loop ; branches to the inner for loop.
.inner_for_loop: 
	ldr r0, [sp] ; loads the value of k into r0. k := 0.
	ldr r1, [sp, #16] ; loads the value of columns into r1. r1 := columns.
	cmp r0, r1 ; compares k < columns.
	bge .end_of_inner_for_loop ; if k >= columns branch to the end of the loop.
	b		.inner_for_loop_body ; otherwise proceed to the body.
.inner_for_loop_body:	
	ldr		r0, [r11, #-4] ; loads the pointer to matrixA to r0 from r11 -4 in memory.
	ldr		r1, [sp, #8] ; loads the value of i into r1. r1 := i.
	ldr		r2, [sp, #16] ; loads the value of columns into r2. r2 := columns.
	ldr		r3, [sp] ; loads the value of k into r3. r3 := k.
	mla		r12, r1, r2, r3 ; r12 := i * columns + k.
	ldr		r0, [r0, r12, lsl #2] ; loads matrix_a[i * columns + k] into r0.
	ldr		r1, [r11, #-8] ; loads the pointer to matrixB to r1 from r11 -8 in memory.
	ldr		r2, [r11, #-12] ; r2 := rows.
	ldr		r12, [sp, #4] ; r12 := j.
	mla		lr, r3, r2, r12 ; lr := k * rows + j.
	ldr		r1, [r1, lr, lsl#2] ; loads matrix_b[k * rows + j] into r1.
	ldr		r2, [sp, #12] ; loads the value of sum into r2, r2 := sum.
	mla		r3, r0, r1, r2 ; r3 := matrix_a[i * columns + k] * matrix_b[k * rows + j] + sum.
	str		r3, [sp, #12] ; updates the value of sum. sum := r3.
	b			.inner_for_loop_next_iteration
.inner_for_loop_next_iteration:
	ldr		r0, [sp] ; r0 := k. The following 2 steps increment k as a part of the for loop.
	add		r0, r0, #1 ; r0++;
	str		r0, [sp] ; k := r0
	b			.inner_for_loop
.end_of_inner_for_loop:
	b			.middle_for_loop_next_iteration
.middle_for_loop_next_iteration:
	ldr		r0, [sp, #4] ; r0 := j
	add		r0, r0, #1 ; r0++
	str		r0, [sp, #4] j := r0.
	b			.middle_for_loop
.end_of_middle_for_loop:
	b			.outer_for_loop_next_iteration
.outer_for_loop_next_iteration:
	ldr		r0, [sp, #8] ; r0 := i
	add		r0, r0, #1 ; r0++
	str		r0, [sp, #8] ; i := r0.
	b			.outer_for_loop
.end_of_outer_for_loop:
	ldr		r0, [sp, #12] ; loads the value of sum into r0. r0 := sum.
	mov		sp, r11 ; copies r11 into stack pointer.
	pop		{r11, lr} ; pops r11 and lr from the stack.
	bx		lr ; sum is returned.
.L__const.main.matrixA:
	.long3@0x3
	.long4@0x4
	.long7@0x7
	.long2@0x2
	.long2@0x2
	.long1@0x1
 	
.L__const.main.matrixB:
 	.long6@0x6
 	.long5@0x5
 	.long2@0x2
 	.long1@0x1
 	.long4@0x4
 	.long5@0x5
 	
.L.str:
 	.asciz"the result of sum of the multiplication of elements is: %d"
 	
