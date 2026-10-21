.macro end
	li	$v0, 10
	syscall
.end_macro 

.macro scanf(%x)
	li $v0, 5
	syscall
	move %x, $v0
.end_macro 

.macro calc_addr(%dst, %row, %column, %rank)
    # dts: the register to save the calculated address
    # row: the row that element is in
    # column: the column that element is in
    # rank: the number of columns in the matrix
    multu %row, %rank
    mflo %dst
    addu %dst, %dst, %column
    sll %dst, %dst, 2
.end_macro

.macro printInt(%src)
    move    $a0, %src
    li      $v0, 1
    syscall
.end_macro

.data
matrix1: .space 256
matrix2: .space 256
str_enter:  .asciiz "\n"
str_space:  .asciiz " "


.text
scanf($s0)		# scanf("%d", &edge)

jal matrix1_input
nop


jal matrix2_input
nop

jal output
nop

end

matrix1_input:
li $t0, 0			# int row = 0
li $t1, 0			# int column = 0

matrix1_outer_input:

beq $t0, $s0, matrix1_end	# 

matrix1_inner_input:
beq $t1, $s0, matrix1_inner_input_end

scanf($t3)

calc_addr($t4, $t0, $t1, $s0)	# matrix1[row][column]

sw $t3, matrix1($t4)		# scanf()

addi $t1, $t1, 1

j matrix1_inner_input

matrix1_inner_input_end:

addi $t0, $t0, 1		# row ++
li $t1, 0			# column = 0

j matrix1_outer_input

matrix1_end:
jr $ra


matrix2_input:
li $t0, 0			# int row = 0
li $t1, 0			# int column = 0

matrix2_outer_input:

beq $t0, $s0, matrix2_end	# 

matrix2_inner_input:
beq $t1, $s0, matrix2_inner_input_end

scanf($t3)

calc_addr($t4, $t0, $t1, $s0)	# matrix1[row][column]

sw $t3, matrix2($t4)		# scanf()

addi $t1, $t1, 1		# column++

j matrix2_inner_input

matrix2_inner_input_end:

addi $t0, $t0, 1		# row++
li $t1, 0			# column = 0

j matrix2_outer_input

matrix2_end:
jr $ra

output:
li $t0, 0			# int row = 0
li $t1, 0			# int column = 0
li $t2, 0			# int k = 0

output_outer_loop:

beq $t0, $s0, output_outer_end	# row == edge

output_inner_loop:
beq $t1, $s0, output_inner_end

li $s1, 0			# result = 0

output_k_loop:
beq $t2, $s0, output_k_end

calc_addr($t3, $t0, $t2, $s0)
calc_addr($t4, $t2, $t1, $s0)

lw $t5, matrix1($t3)
lw $t6, matrix2($t4)

mult $t5, $t6
mflo $t7

add $s1, $s1, $t7		# result += matrix1[row][k] * matrix2[k][column]

addi $t2, $t2, 1		# k++

j output_k_loop

output_k_end:

printInt($s1)			# printf(result)

la $a0, str_space
li $v0, 4
syscall				# print space

addi $t1, $t1, 1		# column++
li $t2, 0			# column = 0

j output_inner_loop

output_inner_end:

la $a0, str_enter
li $v0, 4
syscall				# printf enter

addi $t0, $t0, 1		# row++
li $t1, 0			# column = 0

j output_outer_loop

output_outer_end:

jr $ra