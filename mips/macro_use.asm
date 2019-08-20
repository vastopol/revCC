    # uses array and macros and includes

    .include "macros.S" # for the "done" macro

    .data
array1:        .space    12        #  declare 12 bytes of storage to hold array of 3 integers

    .text
__start:    la    $t0, array1    #  load base address of array into register $t0
    li    $t1, 5        #  $t1 = 5   ("load immediate")
    sw    $t1, ($t0)    #  first array element set to 5; indirect addressing
    li    $t1, 13        #   $t1 = 13
    sw    $t1, 4($t0)    #  second array element set to 13
    li    $t1, -7        #   $t1 = -7
    sw    $t1, 8($t0)    #  third array element set to -7
    done            # macro
