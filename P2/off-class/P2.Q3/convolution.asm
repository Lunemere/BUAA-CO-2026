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
matrix1: .space 484
matrix2: .space 484
str_enter:  .asciiz "\n"
str_space:  .asciiz " "

.text
scanf($s0)		# scanf("%d", &m1)
scanf($s1)		# scanf("%d", &n1)
scanf($s2)		# scanf("%d", &m2)
scanf($s3)		# scanf("%d", &n2)

jal matrix1_input
nop

jal matrix2_input
nop

jal output
nop

end

# =================================== #
# for (int m = 0; m < m1; m++) {
#     for (int n = 0; n < n1; n++) {
#         scanf("%d", &matrix1[m][n]);
#     }
# }
# =================================== #

matrix1_input:
li $t0, 0			                    # int row = 0
li $t1, 0			                    # int column = 0

matrix1_outer_input:

beq $t0, $s0, matrix1_end	            	# m < m1

matrix1_inner_input:
beq $t1, $s1, matrix1_inner_input_end   	# n < n1

scanf($t3)

calc_addr($t4, $t0, $t1, $s1)			# matrix1[row][column]

sw $t3, matrix1($t4)		    		# scanf()

addi $t1, $t1, 1

j matrix1_inner_input

matrix1_inner_input_end:

addi $t0, $t0, 1				# row ++
li $t1, 0					# column = 0

j matrix1_outer_input

matrix1_end:
jr $ra

# =================================== #
# for (int m = 0; m < m2; m++) {
#     for (int n = 0; n < n2; n++) {
#         scanf("%d", &matrix2[m][n]);
#     }
# }
# =================================== #

matrix2_input:
li $t0, 0			            # int row = 0
li $t1, 0			            # int column = 0

matrix2_outer_input:

beq $t0, $s2, matrix2_end	    # m < m2

matrix2_inner_input:
beq $t1, $s3, matrix2_inner_input_end   # n < n2

scanf($t3)

calc_addr($t4, $t0, $t1, $s3)	# matrix1[row][column]

sw $t3, matrix2($t4)		    # scanf()

addi $t1, $t1, 1		        # column++

j matrix2_inner_input

matrix2_inner_input_end:

addi $t0, $t0, 1		        # row++
li $t1, 0			            # column = 0

j matrix2_outer_input

matrix2_end:
jr $ra

# =================================== #
# for (int m = 0; m < m1 - m2 + 1; m++) {
#     for (int n = 0; n < n1 - n2 + 1; n++) {
#         int result = 0;
#         for (int k = 0; k < m2; k++) {
#             for (int l = 0; l < n2; l++) {
#                 result += matrix1[m + k][n + l] * matrix2[k][l];
#             }
#         }
#         printf("%d ", result);
#     }
#     printf("\n");
# }
# =================================== #

output:
addi $sp, $sp, -16
sw $s0, 12($sp)
sw $s1, 8($sp)
sw $s2, 4($sp)
sw $s3, 0($sp)
move $s7, $s1
move $t8, $s3

li $t0, 0			        # int row = 0 m
li $t1, 0			        # int column = 0 n
li $t2, 0			        # int k = 0
li $t3, 0                   		# int l = 0

addi $s4, $s0, 1			# m1 + 1
sub $s4, $s4, $s2			# m1 - m2 + 1

addi $s5, $s1, 1			# n1 + 1
sub $s5, $s5, $s3			# n1 - n2 + 1

output_outer_loop:

beq $t0, $s4, output_outer_end		# row == m1 - m2 + 1

output_inner_loop:
beq $t1, $s5, output_inner_end		# column == n1 - n2 + 1

li $s6, 0				# result = 0

output_k_loop:
beq $t2, $s2, output_k_end		# k = m2

output_j_loop:
beq $t3, $s3, output_j_end		# l = n2

add $t5, $t0, $t2			# m + k
add $t6, $t1, $t3			# n + l

calc_addr($s0, $t5, $t6, $s7)
calc_addr($s1, $t2, $t3, $t8)

lw $t5, matrix1($s0)			# matrix1[m + k][n + l]
lw $t6, matrix2($s1)			# matrix2[k][l]

mult $t5, $t6
mflo $t7

add $s6, $s6, $t7			# result += matrix1[row][k] * matrix2[k][column]

addi $t3, $t3, 1			# l++

j output_j_loop

output_j_end:

li $t3, 0				# $t3 = 0	l

addi $t2, $t2, 1			# k++

j output_k_loop

output_k_end:

printInt($s6)			# printf(result)

la $a0, str_space
li $v0, 4
syscall				# print space

addi $t1, $t1, 1		# column++
li $t2, 0			# k = 0

j output_inner_loop

output_inner_end:

la $a0, str_enter
li $v0, 4
syscall				# printf enter

addi $t0, $t0, 1		# row++
li $t1, 0			# column = 0	n

j output_outer_loop

output_outer_end:

lw $s0, 12($sp)
lw $s1, 8($sp)
lw $s2, 4($sp)
lw $s3, 0($sp)
addi $sp, $sp, 16

jr $ra
