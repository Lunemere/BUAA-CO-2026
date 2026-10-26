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

.macro end
	li $v0, 10
	syscall
.end_macro

.macro calc_addr(%dst, %src)
	sll %dst, %src, 2
.end_macro

.macro printChar(%src)
	li $v0, 11
	move $a0, %src
	syscall
.end_macro

.data
.align 2
st: .space 256
asteroids: .space 256
returnSize: .space 4
asteroidsSize: .space 4
str_space: .asciiz " "
.align 2
str_enter: .asciiz "\n"

.text
scanf($t0)
sw $t0, asteroidsSize					# scanf("%d", &asteroidsSize);

li $t0, 0						# int t = 0

for_loop1:
lw $t1, asteroidsSize					# asteroidsSize
bge $t0, $t1, for_loop1_end				# for (int i = 0; i < asteroidsSize; i++)

scanf($t1)
calc_addr($t2, $t0)					# i's address
sw $t1, asteroids($t2)					# scanf("%d", &asteroids[i]);

addi $t0, $t0, 1					# i++
j for_loop1

for_loop1_end:

li $s0, 0						# int pos = 0

li $t0, 0						# int t = 0
for_loop2:
lw $t1, asteroidsSize
bge $t0, $t1, for_loop2_end				# for (int i = 0; i < asteroidsSize; i++)

li $t1, 1						# int alive = 1

while_loop:
beq $t1, $0, while_loop_end				# alive == 1

calc_addr($t2, $t0)					# i's address
lw $t2, asteroids($t2)					# asteroids[i]
bgez $t2, while_loop_end				# asteroids[i] < 0

blez $s0, while_loop_end				# pos > 0

addi $t3, $s0, -1					# pos - 1
calc_addr($t3, $t3)					# pos - 1 's address
lw $t3, st($t3)						# st[pos - 1]
blez $t3, while_loop_end				# st[pos - 1] > 0

sub $t2, $0, $t2					# -asteroids[i]
slt $t1, $t3, $t2					# alive = st[pos - 1] < -asteroids[i];

bgt $t3, $t2, else1					# if (st[pos - 1] <= -asteroids[i])

addi $s0, $s0, -1					# pos--;

else1:

j while_loop

while_loop_end:

beq $t1, $0, else2

calc_addr($t2, $t0)					# i's address
lw $t2, asteroids($t2)					# asteroids[i]
calc_addr($t3, $s0)					# pos's address
sw $t2, st($t3)						# st[pos] = asteroids[i];
addi $s0, $s0, 1					# pos++

else2:

addi $t0, $t0, 1					# i++
j for_loop2

for_loop2_end:

sw $s0, returnSize					# returnSize = pos;

printInt($s0)						# printf("%d", returnSize)

lw $t0, str_enter					# \n
printChar($t0)						# printf("\n")

li $t0, 0						# int i = 0

for_loop3:
lw $t1, returnSize					# returnSize
bge $t0, $t1, for_loop3_end				# for (int i = 0; i < returnSize; i++)

calc_addr($t1, $t0)					# i's address
lw $t1, st($t1)						# st[i]
printInt($t1)						# printf("%d", st[i]);
lw $t1, str_space
printChar($t1)						# printf(" ")

addi $t0, $t0, 1					# i++
j for_loop3

for_loop3_end:

end