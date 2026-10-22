.macro scanf(%x)
	li $v0, 12
	syscall
	move %x, $v0
.end_macro 

.macro end
	li $v0, 10
	syscall
.end_macro

.macro popin(%x)
	addi $s0, $s0, 1		# stack[++top] = input
	sb %x, stack($s0)		
.end_macro 

.macro popout(%x)
	lb %x, stack($s0)
	addi $s0, $s0, -1		# return stack[top--];
.end_macro 

.data
stack: .space 50


.text
	li $t0, 2
	li $s2, 0			# bool result = true;
	
	li $v0, 5
	syscall
	move $s1, $v0			# scanf("%d", &lines);
	
	div $s1, $t0
	mfhi $t1			# lines % 2
	mflo $t2			# lines / 2

	jal stack_in
	nop
	
	beq $t1, $0, branch1		# if (lines % 2 == 1)
	
	scanf($v0)
	
branch1:	
	jal stack_out
	nop
	
	jal output

	end
	
stack_in:
	li $t3, 0			# int i = 0
	
stack_in_loop:
	beq $t3, $t2, stack_in_end	#	

	scanf($t4)			# scanf("%c", &temp);
	popin($t4)
	
	addi $t3, $t3, 1		# i++
	
	j stack_in_loop
	
stack_in_end:
	jr $ra
	
stack_out:
	li $t3, 0			# int i = 0
	
stack_out_loop:
	beq $t3, $t2, stack_out_end	#	

	scanf($t4)			# scanf("%c", &temp);
	popout($t5)
	
	beq $t4, $t5, branch2		# if (temp != popout())
	li $s2, 1			# result = false;
	
branch2:
	addi $t3, $t3, 1		# i++
	
	j stack_out_loop
	
stack_out_end:
	jr $ra
	
output:
	beq $0, $s2, branch3
	li $a0, 0
	li $v0, 1
	syscall
	jr $ra
	
branch3:
	li $a0, 1
	li $v0, 1
	syscall 
	jr $ra
	