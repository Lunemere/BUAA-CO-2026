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

.eqv FRAME 200

.data
MAX_N: .space 4
arr: .space 80					# int arr[MAX_N];

.text

li $t0, 20
sw $t0, MAX_N					# define MAX_N 20

# =================================== #
# main function
# =================================== #

scanf($s0)					# scanf("%d", &n);

li $t0, 0					# int i = 0

for_loop1:
bge $t0, $s0, for_loop1_end			# for (int i = 0; i < n; i++)

scanf($t1)
sll $t2, $t0, 2
sw $t1, arr($t2)				# scanf("%d", &arr[i]);

addi $t0, $t0, 1

j for_loop1

for_loop1_end:

scanf($s1)					# scanf("%d", &k);

move $a0, $s0					# parameter n
move $a1, $s1					# parameter k

jal kIncreasing					# kIncreasing(arr, n, k)

move $t3, $v0

printInt($t3)					# printf("%d", kIncreasing(arr, n, k));

end

# =================================== #
# kIncreasing function
# $a0 -> arrSize $a1 -> k
# =================================== #
kIncreasing:
Prologue1:
addi $sp, $sp, -FRAME
sw $a0, 196($sp)
sw $a1, 192($sp)
sw $s0, 188($sp)
sw $s1, 184($sp)
sw $s2, 180($sp)
sw $s3, 176($sp)
sw $t0, 172($sp)
sw $t1, 168($sp)
sw $t2, 164($sp)
sw $t3, 160($sp)
sw $t4, 156($sp)
sw $t5, 152($sp)
sw $t6, 148($sp)
sw $ra, 144($sp)

Body1:
move $s0, $a0					# arrSize
move $s1, $a1					# k

li $s2, 0					# int ans = 0;

li $t0, 0					# int i = 0
for_loop2:
bge $t0, $s1, for_loop2_end			# for (int i = 0; i < k; i++)
li $t1, 0					# int m = 0

move $t2, $t0					# int j = i

for_loop2_inner:
bge $t2, $s0, for_loop2_inner_end		# for (int j = i; j < arrSize; j += k)
	sll $t3, $t1, 2				# m
	sll $t4, $t2, 2				# j
	
	lw $t5, arr($t4)			# arr[j]
	add $t3, $t3, $sp
	sw $t5, 0($t3)				# subseq[m++] = arr[j];
	
	addi $t1, $t1, 1			# m++

add $t2, $t2, $s1				# j = j + k
j for_loop2_inner

for_loop2_inner_end:

move $a0, $sp					# parameter subseq
move $a1, $t1					# parameter m

jal computeLIS

move $t2, $v0					# return value int lisLen = computeLIS(subseq, m);

sub $t3, $t1, $t2				# m - lisLen
add $s2, $s2, $t3				# ans += (m - lisLen);

addi $t0, $t0, 1
j for_loop2

for_loop2_end:

move $v0, $s2

Epilogue1:
lw $a0, 196($sp)
lw $a1, 192($sp)
lw $s0, 188($sp)
lw $s1, 184($sp)
lw $s2, 180($sp)
lw $s3, 176($sp)
lw $t0, 172($sp)
lw $t1, 168($sp)
lw $t2, 164($sp)
lw $t3, 160($sp)
lw $t4, 156($sp)
lw $t5, 152($sp)
lw $t6, 148($sp)
lw $ra, 144($sp)
addi $sp, $sp, FRAME

jr $ra

# =================================== #
# computeLIS function
# $a0 -> subseq $a1 -> $a1
# =================================== #

computeLIS:

beq $a1, $0, if					# if (m == 0) return 0;

Prologue2:
addi $sp, $sp, -FRAME
sw $a0, 196($sp)
sw $a1, 192($sp)
sw $s0, 188($sp)
sw $s1, 184($sp)
sw $s2, 180($sp)
sw $s3, 176($sp)
sw $t0, 172($sp)
sw $t1, 168($sp)
sw $t2, 164($sp)
sw $t3, 160($sp)
sw $t4, 156($sp)
sw $t5, 152($sp)
sw $t6, 148($sp)
sw $ra, 144($sp)

Body2:

li $s0, 1				# int maxLen = 1
li $t0, 0				# int i = 0
move $s1, $a0				# subseq
move $s2, $a1				# m

for_loop3:
bge $t0, $s2, for_loop3_end		# for (int i = 0; i < m; i++)

sll $t1, $t0, 2	
add $t1, $t1, $sp			# dp[i] address
li $t2, 1
sw $t2, 0($t1)				# dp[i] = 1;

addi $t0, $t0, 1			# i++
j for_loop3

for_loop3_end:

li $t0, 1				# int i = 1
for_loop4:
bge $t0, $s2, for_loop4_end

li $t1, 0				# int j = 0

for_loop5:
bge $t1, $t0, for_loop5_end		# for (int j = 0; j < i; j++)

sll $t2, $t0, 2
sll $t3, $t1, 2
add $t2, $t2, $s1			# subseq[i]
add $t3, $t3, $s1			# subseq[j]

lw $t2, 0($t2)				# $t2 = subseq[i]
lw $t3, 0($t3)				# $t3 = subseq[j]

blt $t2, $t3, if_finished		# if (subseq[i] >= subseq[j])

sll $t2, $t0, 2				# i
sll $t3, $t1, 2				# j
add $t3, $t3, $sp			# dp[j] address
add $t2, $t2, $sp			# dp[i] address

lw $t3, 0($t3)				# dp[j]
lw $t2, 0($t2)				# dp[i]

addi $t3, $t3, 1			# dp[j] + 1
ble $t3, $t2, if_finished		# if (dp[j] + 1 > dp[i])

sll $t2, $t0, 2				# i
add $t2, $t2, $sp			# dp[i] address
sw $t3, 0($t2)				# dp[i] = dp[j] + 1

if_finished:

addi $t1, $t1, 1
j for_loop5

for_loop5_end:

sll $t2, $t0, 2				# i
add $t2, $t2, $sp			# dp[i] address
lw $t2, 0($t2)				# dp[i]
bgt $s0, $t2, bigger			# maxLen > dp[i]

move $s0, $t2				# maxLen = dp[i]

bigger:

addi $t0, $t0, 1
j for_loop4

for_loop4_end:

move $v0, $s0				# return maxLen

Epilogue2:
lw $a0, 196($sp)
lw $a1, 192($sp)
lw $s0, 188($sp)
lw $s1, 184($sp)
lw $s2, 180($sp)
lw $s3, 176($sp)
lw $t0, 172($sp)
lw $t1, 168($sp)
lw $t2, 164($sp)
lw $t3, 160($sp)
lw $t4, 156($sp)
lw $t5, 152($sp)
lw $t6, 148($sp)
lw $ra, 144($sp)
addi $sp, $sp, FRAME

jr $ra

if: 
li $v0, 0
jr $ra
