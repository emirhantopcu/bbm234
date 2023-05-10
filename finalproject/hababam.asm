	.data
A: 	.word 720, 480, 80, 3, 1, 0 #Do not forget a space after a comma!
OUTPUT:	.asciiz		"The average similarirty score is: "
	.text
	.globl main
main:	la	$t0, A # Load the address of A[0] to register t0
	add	$s1, $0, $0 # initialize s1
	addi	$s2, $0, 6 # s2 = array size
	
for: 	bge 	$s1, $s2, execute_avg # continue if for loop is ended
	lw 		$s3, 0($t0)	# s3 = adress of current index
	
	andi	$t1, $s3, 1	# last digit
	
	beq	$t1, $0, even	
	j		odd
	
even:	srl	$s3, $s3, 3	# shift right to divide by 8 
	sw		$s3, 0($t0)	# updating array 
	addi	$s1, $s1, 1	# i++
	addi	$t0, $t0, 4	# array index up
	j		for
	
odd:	addi	$t1, $s3, 0		# shift left to multiply with 5
	sll		$s3, $s3, 2
	add	$s3, $s3, $t1
	sw		$s3, 0($t0)
	addi	$s1, $s1, 1
	addi	$t0, $t0, 4
	j		for
	
execute_avg:
	la	$t0, A		#initialize avg set t0 adress of A's first index, a0 = n
	addi 	$a0, $a0, 6	
	jal	avg		
	j	done
	
avg:	
	bne  	$a0, 1, else  # if else
	j	if
	
	
if:	
	lw 	$v0, 0($t0) # if 1 array[0] = sum
	j	avg_done_for_1
	
else:	
	sub 	$sp, $sp, 8 #using stack to store values from recursions before
	sw 	$ra, 0($sp) #storing return value
	sw 	$a0, 4($sp) #storing n value
	addi 	$a0, $a0, -1
	jal 	avg #recursive call
	mul     $v0, $v0, $a0
	mul  	$a3, $a0, 4
	add 	$a3, $t0, $a3
	lw	$a2, 0($a3) 
	add	$v0, $v0, $a2
	lw	$a0, 4($sp)
	j	avg_done
					# teacher i'm out of time i won't be able to complete commenting sorry :(
avg_done:
	div 	$v0, $v0, $a0
	lw 	$ra, 0($sp)	
	addi 	$sp, $sp, 8
	jr 	$ra
	
avg_done_for_1:
	div 	$v0, $v0, $a0
	lw 	$ra, 0($sp)	
	jr 	$ra
		
print:	j		done

done:	
	move		$v1, $v0
	li		$v0, 4
	la 		$a0, OUTPUT
	syscall	
	li		$v0, 1
	la		$a0, ($v1)
	syscall
