# random number generator
# it will generate 10 random numbers between 0 and 100

.data
# Create a string to separate the 100 numbers with a space
spacestr: 	.asciiz " "

.text
##############################################################################
# seed the random number generator
##############################################################################

# get the time
li	$v0, 30		# get time in milliseconds (as a 64-bit value)
syscall

move	$t0, $a0	# save the lower 32-bits of time

# seed the random generator (just once)
li	$a0, 1		# random generator id (will be used later)
move 	$a1, $t0	# seed from time
li	$v0, 40		# seed random number generator syscall
syscall

##############################################################################
# seeding done
##############################################################################

# generate 10 random integers in the range 100 from the
# seeded generator (whose id is 1)
li	$t2, 11		# max number of iterations + 1
li	$t3, 0		# current iteration number

LOOP:
li	$a0, 1		# as said, this id is the same as random generator id
li	$a1, 100	# upper bound of the range
li	$v0, 42		# random int range
syscall

# $a0 now holds the random number

# loop terminating condition
addi	$t3, $t3, 1	# increment the number of iterations
beq	$t3, $t2, EXIT	# branch to EXIT if iterations is 10

# $a0 still has the random number
# print it
li	$v0, 1		# print integer syscall
syscall

# print a space
la	$a0, spacestr	# load the address of the string (pseudo-op)
li	$v0, 4		# print string syscall
syscall

# Do another iteration
j	LOOP

##############################################################################
# Tell MARS to exit the program
##############################################################################
EXIT:
li	$v0, 10		# exit syscall
syscall
