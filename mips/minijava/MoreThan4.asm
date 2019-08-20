.data

vmt_MT4:
  MT4.Start
  MT4.Change

.text

  jal Main
  li $v0 10
  syscall

Main:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 20
  sw $ra -4($fp)
  li $a0 4
  jal _heapAlloc
  move $t0 $v0
  la $t9 vmt_MT4
  sw $t9 0($t0)
  bnez $t0 null1
  la $a0 _str0
  j _error
null1:
  lw $t1 0($t0)
  lw $t1 0($t1)
  move $a0 $t0
  li $a1 1
  li $a2 2
  li $a3 3
  li $t9 4
  sw $t9 0($sp)
  li $t9 5
  sw $t9 4($sp)
  li $t9 6
  sw $t9 8($sp)
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 20
  jr $ra

MT4.Start:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 20
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $a1
  move $t2 $a2
  move $t3 $a3
  lw $t4 0($fp)
  lw $t5 4($fp)
  lw $t6 8($fp)
  move $a0 $t1
  jal _print
  move $a0 $t2
  jal _print
  move $a0 $t3
  jal _print
  move $a0 $t4
  jal _print
  move $a0 $t5
  jal _print
  move $a0 $t6
  jal _print
  lw $t7 0($t0)
  lw $t7 4($t7)
  move $a0 $t0
  move $a1 $t6
  move $a2 $t5
  move $a3 $t4
  sw $t3 0($sp)
  sw $t2 4($sp)
  sw $t1 8($sp)
  jalr $t7
  move $t7 $v0
  move $v0 $t7
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 20
  jr $ra

MT4.Change:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a1
  move $t1 $a2
  move $t2 $a3
  lw $t3 0($fp)
  lw $t4 4($fp)
  lw $t5 8($fp)
  move $a0 $t0
  jal _print
  move $a0 $t1
  jal _print
  move $a0 $t2
  jal _print
  move $a0 $t3
  jal _print
  move $a0 $t4
  jal _print
  move $a0 $t5
  jal _print
  li $v0 0
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
