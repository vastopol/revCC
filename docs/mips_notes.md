## Outline

should have parts/sections for code and data separated
globals dont always appear for main in each file
any .globl should appear in the .text
typical assembly code outline

```
.data
        var: .word 0
        str: .stringz "..."

.text
        .globl main

    main:
        ...
        jal fun
        ...
        li    $v0,10        # exit
        syscall

    fun:
        ...
        jr $ra

```

------------------

## Macros

system call 10, exit
```
	.macro done
	li $v0,10
	syscall
	.end_macro

    done
```

syscall 17, exit2
```
    .macro terminate (%termination_value)
    li $a0, %termination_value
    li $v0, 17
    syscall
    .end_macro

    terminate (1)
```

Printing an integer (argument may be either an immediate value or register name):
```
    .macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
	.end_macro

	print_int ($s0)
	print_int (10)
```

Printing a string (macro will first assign a label to its parameter in data segment then print it):
```
	.macro print_str (%str)
	.data
myLabel: .asciiz %str
	.text
	li $v0, 4
	la $a0, myLabel
	syscall
	.end_macro

	print_str ("test1")	#"test1" will be labeled with name "myLabel_M0"
	print_str ("test2")	#"test2" will be labeled with name "myLabel_M1"
```

Implementing a simple for-loop:
```
	# generic looping mechanism
	.macro for (%regIterator, %from, %to, %bodyMacroName)
	add %regIterator, $zero, %from
	Loop:
	%bodyMacroName ()
	add %regIterator, %regIterator, 1
	ble %regIterator, %to, Loop
	.end_macro

	#print an integer
	.macro body()
	print_int $t0
	print_str "\n"
	.end_macro

	#printing 1 to 10:
	for ($t0, 1, 10, body)
```
The for macro has 4 parameters. %regIterator should be the name of a register which iterates from %from to %to and in each iteration %bodyMacroName will be expanded and run.
Arguments for %from and %to can be either a register name or an immediate value, and %bodyMacroName should be name of a macro that has no parameters.

------------------

## registers

32 general purpose registers (32 bits each)

$at, $k0, $k1: reserved for OS and assembler

$a0-$a3:  used to pass first 4 arguments to routine (rest passed on stack)

$v0, $v1: used for return values from functions

$t0-$t9:  caller-saved registers, used to hold temporaries,
          not perserved across calls

$s0-$s7: callee-saved registers, hold long lived data
         should be preserved across calls

$gp:  global pointer points to middle of 64K block in static data segment

addresses in .data are given relative to it:

lw  $v0, 0x20($gp)

$sp: the stack pointer, points to last location on the stack

$fp: frame pointer

------------------

## System calls

    Services 1-17 are compatible with the SPIM simulator.
    Services 30-59 are exclusive to MARS and are not provided by SPIM (not used: 37-39, 45-49)

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
    * read an entire line of input up to and including the newline character.

6. read_float
    * Read floating-point number from user
    * Float returned in $f0
    * read an entire line of input up to and including the newline character.

7. read_double
    * Read double floating-point number from user
    * Double returned in $f0
    * read an entire line of input up to and including the newline character.

8. read_string
    * Works the same as Standard C Library fgets() function.
    * $a0 = memory address of string input buffer
    * $a1 = length of string buffer (n)
    * The programmer must first allocate a buffer to receive the string
    * The service reads up to n-1 characters into a buffer and terminates the string with a null character.
    * If fewer than n-1 characters are in the current line, the service reads up to and including the newline and terminates the string with a null character.    

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
    * open a file
    * $a0 = string containing filename
    * $a1 = flags
    * $a2 = mode
    * $v0 = file descriptor

14. read
    * read from file
    * $a2 = maximum number of characters to read
    * $a1 = address of input buffer
    * $a0 = file descriptor
    * $v0 = number of characters read

15. write
    * write to file
    * $a2 = number of characters to write
    * $a1 = address of output buffer
    * $a0 = file descriptor
    * $v0 = number of characters written

16. close
    * close file
    * $a0 = file descriptor

17. exit2
    * Stops program from running and returns an integer
    * $a0 = result (integer number)

Services 1 - 17 other than Open File (13) compatible as described in the Notes below the table.

Service 8 - Follows semantics of UNIX 'fgets'. For specified length n, string can be no longer than n-1. If less than that, adds newline to end. In either case, then pads with null byte If n = 1, input is ignored and null byte placed at buffer address. If n < 1, input is ignored and nothing is written to the buffer.

Service 11 - Prints ASCII character corresponding to contents of low-order byte.

Service 13 - MARS implements three flag values: 0 for read-only, 1 for write-only with create, and 9 for write-only with create and append. It ignores mode. The returned file descriptor will be negative if the operation failed. The underlying file I/O implementation uses java.io.FileInputStream.read() to read and java.io.FileOutputStream.write() to write. MARS maintains file descriptors internally and allocates them starting with 3. File descriptors 0, 1 and 2 are always open for: reading from standard input, writing to standard output, and writing to standard error, respectively (new in release 4.3).

Services 13,14,15 - In MARS 3.7, the result register was changed to $v0 for SPIM compatability. It was previously $a0 as erroneously printed in Appendix B of Computer Organization and Design,.

Service 17 - If the MIPS program is run under control of the MARS graphical interface (GUI), the exit code in $a0 is ignored.

Service 30 - System time comes from java.util.Date.getTime() as milliseconds since 1 January 1970.

Services 31,33 - Simulate MIDI output through sound card. Details below.

Services 40-44 - use underlying Java pseudorandom number generators provided by the java.util.Random class. Each stream (identified by $a0 contents) is modeled by a different Random object. There are no default seed values, so use the Set Seed service (40) if replicated random sequences are desired.



