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

.data
str_enter: .asciiz "\n"

.text

scanf($s0)					# scanf("%d", &n);

li $t0, 1					# int head = 1;
li $t1, 1					# int step = 1;
li $t2, 1					# int left = 1;

while_loop:
li $t3, 1					# 1
ble $s0, $t3, while_loop_end			# while (n > 1)

bne $t2, $0, if					# left == 1
li $t3, 2
div $s0, $t3					# n % 2
mfhi $t3					# remainder
bne $t3, $0, if					# n % 2 == 1

j if_end

if:

add $t0, $t0, $t1				# head += step;

if_end:

li $t3, 2					# 2
div $s0, $t3
mflo $s0					# n /= 2;
mult $t1, $t3					# step *= 2
mflo $t1
li $t3, 1
sub $t2, $t3, $t2				# left = !left;

j while_loop

while_loop_end:

printInt($t0)					# printf("%d", head)

lw $a0, str_enter
li $v0, 11
syscall						# printf("\n")

end