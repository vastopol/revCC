## Outline

should have parts/sections:
```
    .text
        main:
    .data
```

havent got multi data sections yet
globals dont always appear for main in each file
any .globl should appear in the .text
typical assembly code outline

```
.text
        .globl main

    main:

        ... code ...    

        li    $v0,10        # exit
        syscall


    fun:

        ... code ...

.data

    str: .stringz "..."
    var: .word 0
```

main is more like a special routine with a unique structure
the other functions are called by the main routine
main ends with a load immediate 10 and syscall

the other functions will sometimes have the prologue and epilogue
might adjust stack pointer and also the frame pointer
functions then end with a jr register

main:
sometimes first function and .globl then end on exit
or first things in text is wrapper routine stub to jump to main
then main has more uniform function structure with prologue/epilogue

```
.text

jal main
li $v0 10
syscall

main:
    prologue
    ... code ...
    epilogue
```

prologue/epilogue:
might move the pointers by more if the function takes arguments
then it will subtract sp by 8 + 4 * (# of args)
then variables will be stored to registers from off the stack

```
sw $fp -8($sp)
move $fp $sp
subu $sp $sp 8
sw $ra -4($fp)

... code ...

lw $ra -4($fp)
lw $fp -8($fp)
addu $sp $sp 8
jr $ra
```



functions should have the `}` brace printed for the ```jr $ra```



start each with

```
.data

<VTables>

.text

<Code for Functions>

start each function with

  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp <size of args>
  sw $ra -4($fp)

end each function with

  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra
```


very end of program auxiliary functions

```
AllocArray:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  mul $t1 $t0 4
  addu $t1 $t1 4
  move $a0 $t1
  jal _heapAlloc
  move $t1 $v0
  sw $t0 0($t1)
  move $v0 $t1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

_print:
  li $v0 1   # syscall: print integer
  syscall
  la $a0 _newline
  li $v0 4   # syscall: print string
  syscall
  jr $ra

_error:
  li $v0 4   # syscall: print string
  syscall
  li $v0 10  # syscall: exit
  syscall

_heapAlloc:
  li $v0 9   # syscall: sbrk
  syscall
  jr $ra

.data
.align 0
_newline: .asciiz "\n"
_str0: .asciiz "null pointer\n"
_str1: .asciiz "array index out of bounds\n"
```

------------------

system calls

1. print_int
    * Print integer number (32 bit)
    * $a0 = integer to be printed

2. print_float
    * Print floating-point number (32 bit)
    * $f12 = float to be printed

3. print_double
    * Print floating-point number (64 bit)
    * $f12 = double to be printed

4. print_string
    * Print null-terminated character string
    * $a0 = address of string in memory
    * The service expects the address to start a null-terminated character string.
    * The directive .asciiz creates a null-terminated character string.

5. read_int
    * Read integer number from user
    * Integer returned in $v0

6. read_float
    * Read floating-point number from user
    * Float returned in $f0

7. read_double
    * Read double floating-point number from user
    * Double returned in $f0

8. read_string
    * Works the same as Standard C Library fgets() function.
    * $a0 = memory address of string input buffer
    * $a1 = length of string buffer (n)

9. sbrk
    * Returns the address to a block of memory containing n additional bytes.
    * (Useful for dynamic memory allocation)
    * $a0 = amount
    * address returned in $v0

10. exit
    * Stop program from running

11. print_char
    * Print character
    * $a0 = character to be printed

12. read_char
    * Read character from user
    * Char returned in $v0

13. open

14. read

15. write

16. close

17. exit2
    * Stops program from running and returns an integer
    * $a0 = result (integer number)