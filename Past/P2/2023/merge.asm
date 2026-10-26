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

.macro calc_addr(%dst, %src)
	sll %dst, %src, 2
.end_macro

.macro end
	li $v0, 10
	syscall
.end_macro

.data
nums1: .space 256
nums2: .space 256
nums: .space 512
str_space: .asciiz " "

.text
scanf($s0)					# scanf("%d", &n1);

li $t1, 0					# int i = 0
for_loop1:
bge $t1, $s0, for_loop1_end			# for (int i = 0; i < n1; i++)

scanf($t2)					# scanf("%d", &nums1[i]);
calc_addr($t3, $t1)				# i's address
sw $t2, nums1($t3)

addi $t1, $t1, 1				# i++
j for_loop1

for_loop1_end:

scanf($s1)					# scanf("%d", &n2);
li $t1, 0					# int i = 0
for_loop2:
bge $t1, $s1, for_loop2_end

scanf($t2)					# scanf("%d", &nums2[i]);
calc_addr($t3, $t1)				# i's address
sw $t2, nums2($t3)

addi $t1, $t1, 1				# i++
j for_loop2

for_loop2_end:

li $t0, 0					# i = 0
li $t1, 0					# j = 0
li $t2, 0					# k = 0

while_loop1:
bge $t0, $s0, while_end1			# i >= n1
bge $t1, $s1, while_end1			# j >= n2

calc_addr($t3, $t0)				# i's address
lw $t3, nums1($t3)				# nums1[i]
calc_addr($t4, $t1)				# j's address
lw $t4, nums2($t4)				# nums2[j]

bgt $t3, $t4, else				# nums1[i] > nums2[j]

calc_addr($t4, $t2)				# k's address
sw $t3, nums($t4)				# nums[k++] = nums1[i++];
addi $t0, $t0, 1				# i++
addi $t2, $t2, 1				# k++

j if_finish

else:

calc_addr($t3, $t2)				# k's address
sw $t4, nums($t3)				# nums[k++] = nums2[j++];
addi $t1, $t1, 1				# j++
addi $t2, $t2, 1				# k++

if_finish:

j while_loop1

while_end1:

while_loop2:
bge $t0, $s0, while_loop2_end

calc_addr($t3, $t2)				# k's address
calc_addr($t4, $t0)				# i's address
lw $t4, nums1($t4)				# nums1[i]
sw $t4, nums($t3)				# nums[k++] = nums1[i++];
addi $t2, $t2, 1				# k++
addi $t0, $t0, 1				# i++

j while_loop2

while_loop2_end:

while_loop3:
bge $t1, $s1, while_loop3_end

calc_addr($t3, $t2)				# k's address
calc_addr($t4, $t1)				# j's address
lw $t4, nums2($t4)				# nums2[j]
sw $t4, nums($t3)				# nums[k++] = nums2[j++];
addi $t2, $t2, 1				# k++
addi $t1, $t1, 1				# j++

j while_loop3

while_loop3_end:

li $t3, 0					# int t = 0

for_loop3:
bge $t3, $t2, for_loop3_end			# for (int t = 0; t < k; t++)

calc_addr($t4, $t3)				# t's address
lw $t4, nums($t4)				# nums[t]
printInt($t4)
lw $t5, str_space
move $a0, $t5
li $v0, 11
syscall

addi $t3, $t3, 1
j for_loop3

for_loop3_end:

end