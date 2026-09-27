.macro end                  # end the program
    li      $v0, 10
    syscall
.end_macro

.macro scanf(%x)          		# read the integer
	li $v0, 5
	syscall
	move %x, $v0
.end_macro

.macro address(%x, %i, %j)
	sll %x, %i, 2    		# %x = %i * 4
	add %x, %x, %j			# %x = %x + %j
	sll %x, %x, 2			# %x = %x * 4
.end_macro

.macro printf(%addr)
	la $a0, %addr
	li $v0, 4
	syscall
.end_macro 
	
.macro printInt(%src)
    lw $a0, 0(%src)
    li $v0, 1
    syscall
.end_macro


.data
A: .space 64
row: .space 4
column: .space 4
i: .space 4                		 # locate the datum element
j: .space 4
error_str: .asciiz "Out of bounds"
space: .asciiz " "
enter: .asciiz "\n"
	
.text

main:
    jal input
    nop
    
    jal validate			# check the submatrix
    nop
    
    jal output				# output the submatrix
    nop
    
    end
    
input:
    li $t0, 0           		# the iterator i

input_loop:				
    bge $t0, 16, input_end	
    scanf($t1)
    sll $t2, $t0, 2
    sw $t1, A($t2)			# store the matrix
    addi $t0, $t0, 1			# i = i + 1
    j input_loop
    
input_end:
    scanf($t3)
    sw $t3, row				# read the row
    scanf($t3)
    sw $t3, column			# read the column
    scanf($t3)
    sw $t3, i				# read the i
    scanf($t3)
    sw $t3, j				# read the j
    jr $ra
    
validate:
    lw $t0, row	
    lw $t1, column
    lw $t2, i
    lw $t3, j
    
    add $t4, $t0, $t2			# get matrix row boundaries
    add $t5, $t1, $t3			# get matrix column boundaries
    
    bgt $t4, 4, error
    bgt $t5, 4, error			# stdout the error
    
    jr $ra
    
error:
    printf(error_str)
    end

output:
    lw $t0, column
    lw $t1, i
    lw $t2, j
    lw $t3, row
    la $s0, A
    
    address($t4, $t1, $t2)
    add $t4, $t4, $s0
    
    li $s1, 0
    
output_i_loop:
    bge $s1, $t3, output_end
    
    li $s2, 0
output_j_loop:
    bge $s2, $t0, output_i_loop_end
    
    printInt($t4)
    printf(space)
    
    addi $s2, $s2, 1
    addi $t4, $t4, 4
    
    j output_j_loop
    
output_i_loop_end:
    addi $t1, $t1, 1
    addi $s1, $s1, 1
    address($t4, $t1, $t2)
    add $t4, $t4, $s0
    
    printf(enter)
    
    j output_i_loop
    
output_end:
    jr $ra 
    
    