.macro end
    li      $v0, 10
    syscall
.end_macro

.macro printInt(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
.end_macro

.macro scanf(%x)
	li $v0, 5
	syscall
	move %x, $v0
.end_macro

.macro median(%x, %y, %temp)				# temp = (x + y) / 2
	add %temp, %x, %y
	srl %temp, %temp, 1
.end_macro

.text

main:
	addi $sp, $sp, -12
	sw $s0, 0($sp)					# store the s register to use it
	sw $s1, 4($sp)
	sw $s2, 8($sp)					
	
	scanf($s0)					# scanf("%d", &n);
	
	move $s2, $s0					# upper
	li $s1, 0					# lower
					
	median($s1, $s2, $t0)				# int temp = (lower + upper) / 2;
	
while_loop:
	bgt $s1, $s2, while_end				# while (lower <= upper)
	
	multu $t0, $t0					# temp * temp
	mflo $t1
	
	blt $t1, $s0, branch_if_1
	bgt $t1, $s0, branch_if_2
	
	j while_end
	
branch_if_1:
	add $s1, $t0, 1					# lower = temp + 1;
	median($s1, $s2, $t0)
	j while_loop
	
branch_if_2:
	add $s2, $t0, -1				# upper = temp - 1;
	median($s1, $s2, $t0)	
	j while_loop
	
while_end:
	printInt($t0)					# printf("%d", temp);

	lw $s0, 0($sp)					
	lw $s1, 4($sp)
	lw $s2, 8($sp)	
	addi $sp, $sp, 12
	
	end
