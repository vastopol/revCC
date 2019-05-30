# Compute the value of the sum     1*2 + 2*3 + 3*4 + ... + 10*11,   and store in register $t1

        .data                # variable declaration section

out_string:    .asciiz    "The result is:\n"    # declares a null-terminated string, to "prettify" output

        .text

main:                        # indicates start of code
        li    $t0, 1            # $t0 will be a counter; initialize to 1
        li    $t1, 0            # $t1 will hold the sum
        li    $t2, 10            # $t2 will hold loop limit

loop_top:    bgt    $t0,$t2,loop_end    # exit loop if  $t0 > 10
        addi    $t3,$t0,1        # $t3 = $t0 + 1
        mult    $t0,$t3            # special register  Lo = $t0 * $t3
                        #  (don't need Hi since values are small)
        mflo    $t3            # $t3 = Lo (= $t0 * $t3)
        add    $t1,$t1,$t3        # $t1 = $t1 + $t3
        addi    $t0,$t0, 1            # increment counter
        b    loop_top        # branch to loop_top

loop_end:    # print out the result string
        li    $v0, 4            # system call code for printing string = 4
        la    $a0, out_string        # load address of string to be printed into $a0
        syscall                # call operating system to perform print operation

        # print out integer value in $t1
        li    $v0, 1            # system call code for printing integer = 1
        move    $a0, $t1        # move integer to be printed into $a0:  $a0 = $t1
        syscall                # call operating system to perform print

        # exit program
        li    $v0, 10            # system call code for exit = 10
        syscall                # call operating system

        # blank line at end to keep SPIM happy!