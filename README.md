# revCC

reverse compiler for MIPS assembly to C

* MIPS
  * Mars assembler 4.4 is a lightweight interactive development environment (IDE) for programming in MIPS assembly language,
    intended for educational-level use with Patterson and Hennessy's Computer Organization and Design.

MARS vs SPIM

etc...

https://www.assemblylanguagetuts.com/mips-assembly-data-types/
https://stackoverflow.com/questions/34098596/assembly-files-difference-between-a-s-asm
https://courses.cs.vt.edu/cs2506/Fall2014/Notes/L04.MIPSAssemblyOverview.pdf
https://courses.cs.washington.edu/courses/cse378/03wi/lectures/mips-asm-examples.html
https://ecs-network.serv.pacific.edu/ecpe-170/tutorials/mips-example-programs
https://stackoverflow.com/questions/33062405/why-do-we-use-globl-main-in-mips-assembly-language
https://www.cs.swarthmore.edu/~newhall/cs75/s09/spim_mips_intro.html

compiled c code

http://reliant.colab.duke.edu/c2mips/
https://godbolt.org/
http://www.kurtm.net/mipsasm/index.cgi

----------------------------------------

## Outline

should have parts/sections:
    .text
        main:
    .data

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
