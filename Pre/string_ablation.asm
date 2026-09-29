.macro end
	li $v0, 10
	syscall
.end_macro 

.macro printf(%addr)
	la $a0, (%addr)
	li $v0, 4
	syscall
.end_macro 

.macro getValue(%result, %addr, %x)
	la %result, (%addr)
	add %result, %result, %x
	lb %result, 0(%result)
.end_macro 

.data
input: .space 1002
stack: .space 1001
enter: .asciiz "\n"
empty: .asciiz "EMPTY\n"

.text
main:
li $s0, 0				# int top = 0;
la $s1, input
la $s2, stack	

li $t5, 10				# $t5 = '\n'

li $v0, 8
la $a0, input
li $a1, 1001				# scanf("%s", input);
syscall

li $t0, 0				# int i = 0

for_loop:
	getValue($t1, $s1, $t0)		# $t1 = input[i]
	beq $0, $t1, for_end		# input[i] != '\0'
	beq $t5, $t1, for_end
	
	ble $s0, 0, else_branch		# if (top > 0)
	addi $t2, $s0, -1		# $t2 = top - 1
	getValue($t3, $s2, $t2)		# $t3 = stack[top - 1]
	bne $t3, $t1, else_branch	# if (stack[top - 1] == input[i])
	
	addi $s0, $s0, -1		# top--
	
	addi $t0, $t0, 1		# i++
	j for_loop
	
else_branch:
	sb $t1, stack($s0)		# stack[top] = input[i]
	addi $s0, $s0, 1		# top++
	
	addi $t0, $t0, 1		# i++
	j for_loop
	
for_end:
	beq $0, $s0, if_branch		# if (top == 0)
	
	sb $0, stack($s0)
	printf($s2)
	
	li $a0, 10
	li $v0, 11
	syscall				# printf("\n")
	
	end
	
if_branch:
	la $t4, empty
	printf($t4)			# printf("EMPTY\n");
	
	end
