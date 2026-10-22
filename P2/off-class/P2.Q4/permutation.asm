.macro end
	li	$v0, 10
	syscall
.end_macro 

.macro scanf(%x)
	li $v0, 5
	syscall
	move %x, $v0
.end_macro 

.macro printInt(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
.end_macro

.macro printChar(%src)
	move $a0, %src
	li $v0, 4
	syscall
.end_macro

.data

# =================================== #
# int symbol[7], array[7];
# int n;
# =================================== #

symbol: .space 28
array: .space 28
n: .space 4
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.text

scanf($s0)
sw $s0, n
li $a0, 0
	
jal FullArray
	
end

FullArray:

Prologue:

addi $sp, $sp, -36
sw $ra, 32($sp)
sw $t6, 28($sp)
sw $t0, 24($sp)
sw $t1, 20($sp)
sw $t2, 16($sp)
sw $t3, 12($sp)
sw $t4, 8($sp)
sw $t5, 4($sp)
sw $a0, 0($sp)

Body:

li $t0, 0		# int i = 0
move $t1, $a0		# int index
lw $t2, n		# int n


blt $t1, $t2, if_finished1 	# if (index >= n)

for_loop1:
beq $t0, $t2, for_loop1_end	# for (i = 0; i < n; i++)

sll $t3, $t0, 2			
lw $t4, array($t3)		# array[i]
printInt($t4)
la $t4, str_space		# space
printChar($t4)

addi $t0, $t0, 1		# i++

j for_loop1

for_loop1_end:
la $t4, str_enter
printChar($t4)			# enter
j Epilogue			# return

if_finished1:

for_loop2:
beq $t0, $t2, for_loop2_end	# for (i = 0; i < n; i++)

sll $t3, $t0, 2
lw $t4, symbol($t3)		# symbol[i]

bne $t4, 0, if_finished2	# if (symbol[i] == 0)
sll $t5, $t1, 2			# array[index]
addi $t6, $t0, 1		# i + 1
sw $t6, array($t5)		# array[index] = i + 1;

li $t6, 1			# 1

sw $t6, symbol($t3)		# symbol[i] = 1;

addi $t6, $t1, 1
move $a0, $t6			# FullArray(index + 1);

jal FullArray

sw $0, symbol($t3)		# symbol[i] = 0;

if_finished2:

addi $t0, $t0, 1		# i++

j for_loop2			

for_loop2_end:

Epilogue:

lw $ra, 32($sp)
lw $t6, 28($sp)
lw $t0, 24($sp)
lw $t1, 20($sp)
lw $t2, 16($sp)
lw $t3, 12($sp)
lw $t4, 8($sp)
lw $t5, 4($sp)
lw $a0, 0($sp)

addi $sp, $sp, 36

jr $ra
