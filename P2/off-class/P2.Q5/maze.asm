.macro scanf(%src)
	li $v0, 5
	syscall
	move %src, $v0
.end_macro

.macro printInt(%src)
	move $a0, %src
	li $v0, 1
	syscall
.end_macro

.macro oneAddress(%dst, %column)
	sll %dst, %column, 2
.end_macro

.macro twoAddress(%dst, %row, %column, %rank)
	multu %row, %rank
	mflo %dst
	addu %dst, %dst, %column
	sll %dst, %dst, 2
.end_macro

.macro end
	li $v0, 10
	syscall
.end_macro

.data
n: .space 4
m: .space 4					# int n, m;

maze: .space 196				# int maze[7][7];
visited: .space 196				# int visited[7][7];

dx: .word -1, 1, 0, 0				# int dx[] = {-1, 1, 0, 0};
dy: .word 0, 0, -1, 1				# int dy[] = {0, 0, -1, 1};
rank: .word 7

sx: .space 4					# int sx, sy, ex, ey;
sy: .space 4
ex: .space 4
ey: .space 4
ans: .word 0					# int ans = 0;

str_enter: .asciiz "\n"				# enter

.text

scanf($t0)
sw $t0, n
scanf($t0)
sw $t0, m					# scanf("%d%d", &n, &m);

li $t0, 0					# int i = 0;
lw $s0, n					# n
lw $s1, m					# m

# =================================== #
# for (int i = 0; i < n; i++) {
#     for (int j = 0; j < m; j++) {
#         scanf("%d", &maze[i][j]);
#     }
# }
# =================================== #

for_loop1:
bge $t0, $s0, for_loop1_end			# for (int i = 0; i < n; i++)
li $t1, 0					# int j = 0
for_loop2:
bge $t1, $s1, for_loop2_end			# for (int j = 0; j < m; j++)

scanf($t2)					# scanf
lw $t3, rank					# 7
twoAddress($t4, $t0, $t1, $t3)			# getAddress
sw $t2, maze($t4)				# scanf("%d", &maze[i][j]);

addi $t1, $t1, 1
j for_loop2

for_loop2_end:

addi $t0, $t0, 1
j for_loop1

for_loop1_end:

scanf($t0)
addi $t0, $t0, -1				# sx--;
sw $t0, sx
scanf($t0)
addi $t0, $t0, -1				# sy--;
sw $t0, sy
scanf($t0)
addi $t0, $t0, -1				# ex--;
sw $t0, ex
scanf($t0)
addi $t0, $t0, -1				# ey--;
sw $t0, ey					# scanf("%d%d%d%d", &sx, &sy, &ex, &ey);

lw $t0, sx
lw $t1, sy
lw $t2, rank					# 7
twoAddress($t3, $t0, $t1, $t2)			# maze[sx][sy] address
lw $t4, maze($t3)				# maze[sx][sy]

bne $t4, $0, ELSE				# maze[sx][sy] == 0

lw $t0, ex
lw $t1, ey
twoAddress($t3, $t0, $t1, $t2)			# maze[ex][ey] address
lw $t4, maze($t3)				# maze[ex][ey]

bne $t4, $0, ELSE				# maze[ex][ey] == 0

lw $a0, sx					# sx
lw $a1, sy					# sy
jal dfs						# dfs(sx, sy)

ELSE:

lw $t0, ans
printInt($t0)					# print ans

lw $a0, str_enter
li $v0, 11
syscall						# print enter

end

# ===================================== #
# $a0 -> x, $a1 -> y
# ===================================== #

dfs:

Prologue:
addi $sp, $sp, -56				# put in stack
sw $s0, 52($sp)
sw $s1, 48($sp)
sw $s2, 44($sp)
sw $s3, 40($sp)
sw $t0, 36($sp)
sw $t1, 32($sp)
sw $t2, 28($sp)
sw $t3, 24($sp)
sw $t4, 20($sp)
sw $t5, 16($sp)
sw $t6, 12($sp)
sw $a0, 8($sp)
sw $a1, 4($sp)
sw $ra, 0($sp)

Body:
move $s0, $a0					# int x
move $s1, $a1					# int y

lw $t0, ex
lw $t1, ey

bne $s0, $t0, ELSE1
bne $s1, $t1, ELSE1				# if (x == ex && y == ey)
lw $t2, ans					# ans
addi $t2, $t2, 1
sw $t2, ans					# ans++

j Epilogue

ELSE1:
lw $t0, rank
twoAddress($t1, $s0, $s1, $t0)			# visited[x][y] address
li $t0, 1
sw $t0, visited($t1)					# visited[x][y] = 1;

li $t0, 0					# int i = 0
li $s2, 4					# 4

for_loop3:
bge $t0, $s2, for_loop3_end			# for (int i = 0; i < 4; i++)

oneAddress($t1, $t0)				# i
lw $t2, dx($t1)					# dx[i]
add $t1, $s0, $t2				# int nx = x + dx[i];

oneAddress($t2, $t0)
lw $t3, dy($t2)					# dy[i]
add $t2, $s1, $t3				# int ny = y + dy[i];

blt $t1, $0, continue				# nx < 0
lw $t3, n					# n
bge $t1, $t3, continue				# nx >= n
blt $t2, $0, continue				# ny < 0
lw $t3, m					# m
bge $t2, $t3, continue				# ny >= m

lw $t4, rank					# 7
twoAddress($t3, $t1, $t2, $t4)			# maze[nx][ny] address
lw $t3, maze($t3)				# maze[nx][ny]

li $t5, 1
beq $t3, $t5, continue				# maze[nx][ny] == 1
twoAddress($t3, $t1, $t2, $t4)			# visited[nx][ny] address
lw $t3, visited($t3)				# visited[nx][ny]
beq $t3, $t5, continue				# visited[nx][ny] == 1

move $a0, $t1					# parameter x
move $a1, $t2					# parameter y

jal dfs

continue:

addi $t0, $t0, 1
j for_loop3

for_loop3_end:

lw $t0, rank					# 7
twoAddress($t1, $s0, $s1, $t0)			# visited[x][y] address
sw $0, visited($t1)				# visited[x][y] = 0;

Epilogue:
lw $s0, 52($sp)
lw $s1, 48($sp)
lw $s2, 44($sp)
lw $s3, 40($sp)
lw $t0, 36($sp)
lw $t1, 32($sp)
lw $t2, 28($sp)
lw $t3, 24($sp)
lw $t4, 20($sp)
lw $t5, 16($sp)
lw $t6, 12($sp)
lw $a0, 8($sp)
lw $a1, 4($sp)
lw $ra, 0($sp)

addi $sp, $sp, 56				# get out stack

jr $ra