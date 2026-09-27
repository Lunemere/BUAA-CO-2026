.macro printInt(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
.end_macro						# input the int value, then print it

.macro scanf(%x)
	li $v0, 5
	syscall
	move %x, $v0
.end_macro						# read the int from the stdin and store it into %x

.macro end
    li      $v0, 10
    syscall
.end_macro

.text
main:
	addi $sp, $sp, -12				# store the $s0, $s1, $s2
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)

	li $s0, 0					# int max = 0
	li $s1, 0					# int altitude = 0;

	scanf($s2)					# scanf("%d", &n);
	li $t1, 0					# int i = 0

read_loop:
	bge $t1, $s2, read_end 
	
	scanf($t0)					# scanf("%d", &temp);

	add $s1, $s1, $t0				# altitude += temp;
	addi $t1, $t1, 1				# i++

	ble $s1, $s0, read_loop			# if (altitude > max)
	
	move $s0, $s1					# max = altitude;
	
	j read_loop
	
read_end:
	printInt($s0)					# printf("%d", max);
	
	lw $s0, 8($sp) 
	lw $s1, 4($sp)
	lw $s2, 0($sp)
	addi $sp, $sp, 12
	
	end
