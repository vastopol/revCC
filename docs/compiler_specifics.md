## Various possible main function prototypes

```
// assembly
main:

// C
int main();
int main(void);
int main(int argc, char **argv);
int main(int argc, char *argv[]);
int main(int argc, char *argv[], char *envp[]);

// Java
public static void main(String[] args)

```

main is more like a special routine with a unique structure
the other functions are called by the main routine
main ends with a load immediate 10 and syscall

main is usually the first function and often is .globl then ends on exit
some compilers make the first instructions as a wrapper stub to jump to main
then all functions have the same structure with prologue/epilogue
not all hand written/manual assembly have the prologue/epilogue, its mostly Various
other functions are only identified as `function` since type information isn't recovered yet.

------------------

## prologue/epilogue:

compiler generated code
might move the pointers by more if the function takes arguments
then it will subtract sp by 8 + 4 * (# of args)
then variables will be stored to registers from off the stack

most/all functions will have the prologue and epilogue
adjust stack pointer and also the frame pointer
functions then end with a jr register

```
.text

    main:
        # prologue
        ...
        # epilogue

    fun:
        # prologue
        ...
        # epilogue
```

where the function prolouge/epilouge are:
```
    # prologue
    sw $fp -8($sp)
    move $fp $sp
    subu $sp $sp <size of args>
    sw $ra -4($fp)
    ...
    # epilogue
    lw $ra -4($fp)
    lw $fp -8($fp)
    addu $sp $sp <size of args>
    jr $ra
```

functions should have the `}` brace printed for the ```jr $ra```

------------------

## Object Oriented layout example

Heavily based on Mini Java

```
.data

    # Each class has vtable for virtual method calls
    Vmt_A:
        A.fun1
        A.fun2

    Vmt_B:
        B.fun3

        ...

.text

        # entry point wrapper (initializer)
        ...
        jal main
        li $v0 10
        syscall

    main:
        # prologue
        ...
        # epilogue

    A.fun1:
        # prologue
        ...
        # epilogue

    A.fun2:
        # prologue
        ...
        # epilogue

        ...
```


example auxiliary functions

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