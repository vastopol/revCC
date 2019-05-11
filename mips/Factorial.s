.data

vmt_Fac:
  Fac.ComputeFac

.text

  jal main
  li $v0, 10
  syscall

main:
  sw $fp, -8($sp)
  move $fp, $sp
  subu $sp, $sp, 8
  sw $ra, -4($fp)
  li $a0, 4
  jal _heapAlloc
  move $t0, $v0
  la $t9, vmt_Fac
  sw $t9, 0($t0)
  bnez $t0, null1
  la $a0, _str0
  j _error
null1:
  lw $t1, 0($t0)
  lw $t1, 0($t1)
  move $a0, $t0
  li $a1, 10
  jalr $t1
  move $t1, $v0
  move $a0, $t1
  jal _print
  lw $ra, -4($fp)
  lw $fp, -8($fp)
  addu $sp, $sp, 8
  jr $ra

Fac.ComputeFac:
  sw $fp, -8($sp)
  move $fp, $sp
  subu $sp, $sp 12
  sw $ra, -4($fp)
  sw $s0, 0($sp)
  move $t0, $a0
  move $s0, $a1
  slti $t1, $s0, 1
  beqz $t1, if1_else
  li $t1, 1
  j if1_end
if1_else:
  lw $t2, 0($t0)
  lw $t2, 0($t2)
  subu $t3, $s0, 1
  move $a0, $t0
  move $a1, $t3
  jalr $t2
  move $t3, $v0
  mul $t1, $s0, $t3
if1_end:
  move $v0, $t1
  lw $s0, 0($sp)
  lw $ra, -4($fp)
  lw $fp, -8($fp)
  addu $sp, $sp, 12
  jr $ra

_print:
  li $v0, 1   # syscall: print integer
  syscall
  la $a0, _newline
  li $v0, 4   # syscall: print string
  syscall
  jr $ra

_error:
  li $v0, 4   # syscall: print string
  syscall
  li $v0, 10  # syscall: exit
  syscall

_heapAlloc:
  li $v0, 9   # syscall: sbrk
  syscall
  jr $ra

.data
.align 0
_newline: .asciiz "\n"
_str0:    .asciiz "null pointer\n"
