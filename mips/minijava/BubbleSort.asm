.data

vmt_BBS:
  BBS.Start
  BBS.Sort
  BBS.Print
  BBS.Init

.text

  jal Main
  li $v0 10
  syscall

Main:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  li $a0 12
  jal _heapAlloc
  move $t0 $v0
  la $t9 vmt_BBS
  sw $t9 0($t0)
  bnez $t0 null1
  la $a0 _str0
  j _error
null1:
  lw $t1 0($t0)
  lw $t1 0($t1)
  move $a0 $t0
  li $a1 10
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

BBS.Start:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 12
  sw $ra -4($fp)
  sw $s0 0($sp)
  move $s0 $a0
  move $t0 $a1
  lw $t1 0($s0)
  lw $t1 12($t1)
  move $a0 $s0
  move $a1 $t0
  jalr $t1
  lw $t1 0($s0)
  lw $t1 8($t1)
  move $a0 $s0
  jalr $t1
  li $a0 99999
  jal _print
  lw $t1 0($s0)
  lw $t1 4($t1)
  move $a0 $s0
  jalr $t1
  lw $t1 0($s0)
  lw $t1 8($t1)
  move $a0 $s0
  jalr $t1
  li $v0 0
  lw $s0 0($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 12
  jr $ra

BBS.Sort:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  lw $t1 8($t0)
  subu $t1 $t1 1
  li $t2 -1
while1_top:
  slt $t3 $t2 $t1
  beqz $t3 while1_end
  li $t3 1
while2_top:
  addu $t4 $t1 1
  slt $t4 $t3 $t4
  beqz $t4 while2_end
  subu $t4 $t3 1
  lw $t5 4($t0)
  bnez $t5 null2
  la $a0 _str0
  j _error
null2:
  lw $t6 0($t5)
  sltu $t6 $t4 $t6
  bnez $t6 bounds1
  la $a0 _str1
  j _error
bounds1:
  mul $t6 $t4 4
  addu $t6 $t6 $t5
  lw $t6 4($t6)
  lw $t5 4($t0)
  bnez $t5 null3
  la $a0 _str0
  j _error
null3:
  lw $t4 0($t5)
  sltu $t4 $t3 $t4
  bnez $t4 bounds2
  la $a0 _str1
  j _error
bounds2:
  mul $t4 $t3 4
  addu $t4 $t4 $t5
  lw $t4 4($t4)
  slt $t4 $t4 $t6
  beqz $t4 if1_else
  subu $t4 $t3 1
  lw $t6 4($t0)
  bnez $t6 null4
  la $a0 _str0
  j _error
null4:
  lw $t5 0($t6)
  sltu $t5 $t4 $t5
  bnez $t5 bounds3
  la $a0 _str1
  j _error
bounds3:
  mul $t5 $t4 4
  addu $t5 $t5 $t6
  lw $t5 4($t5)
  lw $t6 4($t0)
  bnez $t6 null5
  la $a0 _str0
  j _error
null5:
  lw $t7 0($t6)
  sltu $t7 $t4 $t7
  bnez $t7 bounds4
  la $a0 _str1
  j _error
bounds4:
  mul $t7 $t4 4
  addu $t7 $t7 $t6
  lw $t6 4($t0)
  bnez $t6 null6
  la $a0 _str0
  j _error
null6:
  lw $t4 0($t6)
  sltu $t4 $t3 $t4
  bnez $t4 bounds5
  la $a0 _str1
  j _error
bounds5:
  mul $t4 $t3 4
  addu $t4 $t4 $t6
  lw $t4 4($t4)
  sw $t4 4($t7)
  lw $t4 4($t0)
  bnez $t4 null7
  la $a0 _str0
  j _error
null7:
  lw $t7 0($t4)
  sltu $t7 $t3 $t7
  bnez $t7 bounds6
  la $a0 _str1
  j _error
bounds6:
  mul $t7 $t3 4
  addu $t7 $t7 $t4
  sw $t5 4($t7)
  j if1_end
if1_else:
if1_end:
  addu $t3 $t3 1
  j while2_top
while2_end:
  subu $t1 $t1 1
  j while1_top
while1_end:
  li $v0 0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

BBS.Print:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  li $t1 0
while3_top:
  lw $t2 8($t0)
  slt $t2 $t1 $t2
  beqz $t2 while3_end
  lw $t2 4($t0)
  bnez $t2 null8
  la $a0 _str0
  j _error
null8:
  lw $t3 0($t2)
  sltu $t3 $t1 $t3
  bnez $t3 bounds7
  la $a0 _str1
  j _error
bounds7:
  mul $t3 $t1 4
  addu $t3 $t3 $t2
  lw $t3 4($t3)
  move $a0 $t3
  jal _print
  addu $t1 $t1 1
  j while3_top
while3_end:
  li $v0 0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

BBS.Init:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 12
  sw $ra -4($fp)
  sw $s0 0($sp)
  move $s0 $a0
  move $t0 $a1
  sw $t0 8($s0)
  move $a0 $t0
  jal AllocArray
  move $t0 $v0
  sw $t0 4($s0)
  lw $t0 4($s0)
  bnez $t0 null9
  la $a0 _str0
  j _error
null9:
  lw $t1 0($t0)
  li $t9 0
  sltu $t1 $t9 $t1
  bnez $t1 bounds8
  la $a0 _str1
  j _error
bounds8:
  li $t1 0
  addu $t1 $t1 $t0
  li $t9 20
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null10
  la $a0 _str0
  j _error
null10:
  lw $t0 0($t1)
  li $t9 1
  sltu $t0 $t9 $t0
  bnez $t0 bounds9
  la $a0 _str1
  j _error
bounds9:
  li $t0 4
  addu $t0 $t0 $t1
  li $t9 7
  sw $t9 4($t0)
  lw $t0 4($s0)
  bnez $t0 null11
  la $a0 _str0
  j _error
null11:
  lw $t1 0($t0)
  li $t9 2
  sltu $t1 $t9 $t1
  bnez $t1 bounds10
  la $a0 _str1
  j _error
bounds10:
  li $t1 8
  addu $t1 $t1 $t0
  li $t9 12
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null12
  la $a0 _str0
  j _error
null12:
  lw $t0 0($t1)
  li $t9 3
  sltu $t0 $t9 $t0
  bnez $t0 bounds11
  la $a0 _str1
  j _error
bounds11:
  li $t0 12
  addu $t0 $t0 $t1
  li $t9 18
  sw $t9 4($t0)
  lw $t0 4($s0)
  bnez $t0 null13
  la $a0 _str0
  j _error
null13:
  lw $t1 0($t0)
  li $t9 4
  sltu $t1 $t9 $t1
  bnez $t1 bounds12
  la $a0 _str1
  j _error
bounds12:
  li $t1 16
  addu $t1 $t1 $t0
  li $t9 2
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null14
  la $a0 _str0
  j _error
null14:
  lw $t0 0($t1)
  li $t9 5
  sltu $t0 $t9 $t0
  bnez $t0 bounds13
  la $a0 _str1
  j _error
bounds13:
  li $t0 20
  addu $t0 $t0 $t1
  li $t9 11
  sw $t9 4($t0)
  lw $t0 4($s0)
  bnez $t0 null15
  la $a0 _str0
  j _error
null15:
  lw $t1 0($t0)
  li $t9 6
  sltu $t1 $t9 $t1
  bnez $t1 bounds14
  la $a0 _str1
  j _error
bounds14:
  li $t1 24
  addu $t1 $t1 $t0
  li $t9 6
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null16
  la $a0 _str0
  j _error
null16:
  lw $t0 0($t1)
  li $t9 7
  sltu $t0 $t9 $t0
  bnez $t0 bounds15
  la $a0 _str1
  j _error
bounds15:
  li $t0 28
  addu $t0 $t0 $t1
  li $t9 9
  sw $t9 4($t0)
  lw $t0 4($s0)
  bnez $t0 null17
  la $a0 _str0
  j _error
null17:
  lw $t1 0($t0)
  li $t9 8
  sltu $t1 $t9 $t1
  bnez $t1 bounds16
  la $a0 _str1
  j _error
bounds16:
  li $t1 32
  addu $t1 $t1 $t0
  li $t9 19
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null18
  la $a0 _str0
  j _error
null18:
  lw $t0 0($t1)
  li $t9 9
  sltu $t0 $t9 $t0
  bnez $t0 bounds17
  la $a0 _str1
  j _error
bounds17:
  li $t0 36
  addu $t0 $t0 $t1
  li $t9 5
  sw $t9 4($t0)
  li $v0 0
  lw $s0 0($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 12
  jr $ra

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
