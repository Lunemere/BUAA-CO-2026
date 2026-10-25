.macro scanf(%src)
	li $v0, 5
	syscall
	move %src, $v0
.end_macro

.macro printInt(%src)
	li $v0, 1
	move $a0, %src
	syscall
.end_macro

.macro printChar(%src)
	li $v0, 11
	move $a0, %src
	syscall
.end_macro

.data
n: .space 4					# int n;
best_area: .space 8				# long long best_area = 0;
str_space: .asciiz " "
replenish: .space 2				
str_enter: .asciiz "\n"				# enter

.text

scanf($t0)					# scanf("%d", &n);
sw $t0, n

# =================================== #
# long long best_area = 0;
# int best_x = 0, best_y = 0;
# =================================== #

li $s0, 0					# best_x
li $s1, 0					# best_y

li $s2, 0					# int i = 0

for_loop:
lw $t0, n				
beq $s2, $t0, for_loop_end			# for (int i = 0; i < n; i++)

scanf($t0)					# x scanf
scanf($t1)					# y scanf

beq $t0, $0, continue				# x == 0
beq $t1, $0, continue				# y == 0

bgt $t0, $0, condition1				# x > 0
blt $t0, $0, condition2				# x < 0
j body

condition1:
bgt $t1, $0, continue				# y > 0
j body

condition2:
blt $t1, $0, continue				# y < 0
j body

body:
abs $t7, $t0					# int ax = x >= 0 ? x : -x;
abs $t8, $t1					# int ay = y >= 0 ? y : -y;

mult $t7, $t8
mfhi $t3					# high
mflo $t2					# low	area

li $t5 4
lw $t5, best_area($t5)				# high	
lw $t4, best_area				# low	best_area

slt $t6, $t3, $t5 				# $t6 = 1 if $t3 < $t5
bne $t6, $0, LESS				# area < best_area
# $t3 >= $t5
bne $t3, $t5, NOT_LESS				# $t3 > $t5
# $t3 == $t5
sleu $t6, $t2, $t4				# $s6 = 1 if $t2 <= $t4
bne $t6, $0, LESS
# $t2 > $t4

NOT_LESS:
li $t6, 4
sw $t3, best_area($t6)
sw $t2, best_area				# best_area = area;
move $s0, $t0					# best_x = x;
move $s1, $t1					# best_y = y;

LESS:

continue:

addi $s2, $s2, 1
j for_loop 

for_loop_end:

# =================================== #
# printf("%d %d\n", best_x, best_y);
# =================================== #

printInt($s0)
lw $t0, str_space
printChar($t0)	
printInt($s1)
lw $t1, str_enter
printChar($t1)


