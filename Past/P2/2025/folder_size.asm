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

.macro oneAddress(%dst, %src)
	sll %dst, %src, 2
.end_macro

.macro end
	li $v0, 10
	syscall
.end_macro

.eqv MAXN 620
.eqv MAXE 3220

.data
n: .space 4
nodeType: .space MAXN
fileSizeVal: .space MAXN
headAdj: .space MAXN
toEdge: .space MAXE
nextEdge: .space MAXE
edgeCnt: .space 4
str_enter: .asciiz "\n"

.text

li $t0, 0						# int i = 0

for_loop1:
li $t1, 155						# MAXN
bge $t0, $t1, for_loop1_end				# for(int i=0; i<MAXN; i++)
oneAddress($t1, $t0)
li $t2, -1
sw $t2, headAdj($t1)					# headAdj[i] = -1;

addi $t0, $t0, 1					# i++
j for_loop1

for_loop1_end:

li $t0, 0
sw $t0, edgeCnt						# edgeCnt = 0;

scanf($t0)						# scanf("%d", &n);
sw $t0, n						# store $t0 to n

li $t0, 1						# int i = 1;
lw $s0, n						# n

for_loop2:
bgt $t0, $s0, for_loop2_end				# for (int i = 1; i <= n; i++);

scanf($t1)						# scanf("%d", &t); 

beq $t1, $0, if1					# if (t == 0)

oneAddress($t2, $t0)					# i's address
li $t3, 1
sw $t3, nodeType($t2)					# nodeType[i] = 1;
scanf($t2)						# scanf("%d", &k);

li $t3, 0						# int j = 0

for_loop3:
bge $t3, $t2, for_loop3_end				# for (int j = 0; j < k; j++)

scanf($t4)						# scanf("%d", &v);

move $a0, $t0						# parameter1 i
move $a1, $t4						# parameter2 v

jal add_edge						# add_edge(i, v);

addi $t3, $t3, 1
j for_loop3

for_loop3_end:

j if1_end

if1:
oneAddress($t2, $t0)					# i's address
sw $0, nodeType($t2)					# nodeType[i] = 0;
scanf($t3)						# scanf("%d", &x); 
sw $t3, fileSizeVal($t2)				# fileSizeVal[i] = x;

if1_end:

addi $t0, $t0, 1					# i++
j for_loop2

for_loop2_end:

scanf($t0)						# scanf("%d", &q);

while_loop:
beq $0, $t0, while_loop_end				# while (q--)

scanf($t1)						# scanf("%d", &id);
move $a0, $t1						# parameter id
jal dfs_sum
move $t2, $v0						# return value
printInt($t2)
lw $t3, str_enter
move $a0, $t3						# printf("%d\n", ans);
li $v0, 11
syscall							# print \n

addi $t0, $t0, -1					# q--
j while_loop

while_loop_end:

end

# ========================================== #
# void add_edge(int u, int v)
# $a0 -> u, $a1 -> v
# ========================================== #

add_edge:

Prologue1:

addi $sp, $sp, -48
sw $ra, 44($sp)
sw $v0, 40($sp)
sw $s0, 36($sp)
sw $s1, 32($sp)
sw $s2, 28($sp)
sw $t0, 24($sp)
sw $t1, 20($sp)
sw $t2, 16($sp)
sw $t3, 12($sp)
sw $t4, 8($sp)
sw $a0, 4($sp)
sw $a1, 0($sp)

Body1:

lw $t0, edgeCnt						# edgeCnt
oneAddress($t0, $t0)
sw $a1, toEdge($t0)					# toEdge[edgeCnt] = v;

oneAddress($t1, $a0)					# u's address
lw $t2, headAdj($t1)					# headAdj[u];
sw $t2, nextEdge($t0)					# nextEdge[edgeCnt] = headAdj[u];

lw $t0, edgeCnt						# edgeCnt
sw $t0, headAdj($t1)					# headAdj[u] = edgeCnt;
addi $t0, $t0, 1					
sw $t0, edgeCnt						# edgeCnt++

Epilogue1:

lw $ra, 44($sp)
lw $v0, 40($sp)
lw $s0, 36($sp)
lw $s1, 32($sp)
lw $s2, 28($sp)
lw $t0, 24($sp)
lw $t1, 20($sp)
lw $t2, 16($sp)
lw $t3, 12($sp)
lw $t4, 8($sp)
lw $a0, 4($sp)
lw $a1, 0($sp)

addi $sp, $sp, 48

jr $ra

# ==================================== #
# int dfs_sum(int u)
# $a0 -> u
# ==================================== #

dfs_sum:

Prologue2:

addi $sp, $sp, -44
sw $ra, 40($sp)
sw $s0, 36($sp)
sw $s1, 32($sp)
sw $s2, 28($sp)
sw $t0, 24($sp)
sw $t1, 20($sp)
sw $t2, 16($sp)
sw $t3, 12($sp)
sw $t4, 8($sp)
sw $a0, 4($sp)
sw $a1, 0($sp)

Body2:

oneAddress($t1, $a0)						# u's address
lw $t0, nodeType($t1)						# nodeType[u]

beq $0, $t0, return1

li $t0, 0							# int size = 0;
lw $t2, headAdj($t1)						# int e = headAdj[u]

for_loop4:
li $t3, -1							# e != -1
beq $t2, $t3, for_loop4_end					# for (int e = headAdj[u]; e != -1; e = nextEdge[e])

oneAddress($t3, $t2)						# e's address
lw $t3, toEdge($t3)						# int v = toEdge[e];
move $a0, $t3							# parameter v
jal dfs_sum

add $t0, $t0, $v0						# size += dfs_sum(v);

oneAddress($t3, $t2)						# e's address
lw $t2, nextEdge($t3)
j for_loop4

for_loop4_end:

move $v0, $t0							# return size;

Epilogue2:

lw $ra, 40($sp)
lw $s0, 36($sp)
lw $s1, 32($sp)
lw $s2, 28($sp)
lw $t0, 24($sp)
lw $t1, 20($sp)
lw $t2, 16($sp)
lw $t3, 12($sp)
lw $t4, 8($sp)
lw $a0, 4($sp)
lw $a1, 0($sp)

addi $sp, $sp, 44

jr $ra

return1:
oneAddress($t1, $a0)
lw $v0, fileSizeVal($t1)
j Epilogue2