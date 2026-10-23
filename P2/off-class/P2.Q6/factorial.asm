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

.data
n: .space 4			# int n;
a: .space 4000			# int a[1000] = {0};
str_enter: .asciiz "\n"		# enter

.text
scanf($t0)			# scanf("%d", &n);
sw $t0, n
li $s2, 10			# 10

li $s0, 1			# int len = 1;
sw $s0, a			# a[0] = 1;

li $s1, 2			# int i = 2

for_loop1:
lw $t0, n			# n
bgt $s1, $t0, for_loop1_end	# for (int i = 2; i <= n; i++)

li $t0, 0			# int carry = 0;

li $t1, 0			# int j = 0

for_loop2:
beq $t1, $s0, for_loop2_end	# for (int j = 0; j < len; j++)

sll $t2, $t1, 2
lw $t3, a($t2)			# a[j]
mult $t3, $s1			# a[j] * i

mflo $t3

add $t3, $t3, $t0		# int temp = a[j] * i + carry;
div $t3, $s2

mfhi $t4			# remainder
mflo $t0			# quotient || carry = temp / 10;

sw $t4, a($t2)			# a[j] = temp % 10;

addi $t1, $t1, 1

j for_loop2

for_loop2_end:

ble $t0, $0, while_finished
sll $t2, $s0, 2
div $t0, $s2

mfhi $t4
mflo $t0			# carry /= 10;

sw $t4, a($t2)			# a[len] = carry % 10;

addi $s0, $s0, 1
j for_loop2_end

while_finished:

addi $s1, $s1, 1

j for_loop1

for_loop1_end:

addi $s1, $s0, -1		# int i = len - 1

for_loop3:

blt $s1, $0, for_loop3_end	# for (int i = len - 1; i >= 0; i--)

sll $t2, $s1, 2			
lw $t0, a($t2)			# a[i]

printInt($t0)			# printf("%d", a[i]);

addi $s1, $s1, -1

j for_loop3

for_loop3_end:

la $a0, str_enter

li $v0, 4
syscall
