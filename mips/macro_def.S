
    # exit
    .macro done
    li $v0,10
    syscall
    .end_macro

####################

    # exit2
    .macro terminate (%termination_value)
    li $a0, %termination_value
    li $v0, 17
    syscall
    .end_macro

####################

    # print_int
    .macro print_int (%x)
    li $v0, 1
    add $a0, $zero, %x
    syscall
    .end_macro

####################

    # print_str
    .macro print_str (%str)
    .data
myLabel: .asciiz %str
    .text
    li $v0, 4
    la $a0, myLabel
    syscall
    .end_macro

####################

    # generic looping mechanism
    .macro for (%regIterator, %from, %to, %bodyMacroName)
    add %regIterator, $zero, %from
    Loop:
    %bodyMacroName ()
    add %regIterator, %regIterator, 1
    ble %regIterator, %to, Loop
    .end_macro

    # print an integer
    .macro body()
    print_int $t0
    print_str "\n"
    .end_macro

####################

