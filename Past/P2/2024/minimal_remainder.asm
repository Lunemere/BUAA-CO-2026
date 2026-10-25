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

.text

scanf($s0)						# b
scanf($s1)						# m
scanf($s2)						# scanf("%d%d%d", &b, &m, &n); n

move $t0, $s0						# int result = b

move $t1, $s1						# int i = m

for_loop:
bgt $t1, $s2, for_loop_end				# for (int i = m; i <= n; i++)

div $t1, $s0						# i % b
mfhi $t2						# remainder

ble $t0, $t2, ELSE					# if (result > remainder)

move $t0, $t2						# result = remainder

ELSE:

addi $t1, $t1, 1
j for_loop

for_loop_end:

printInt($t0)