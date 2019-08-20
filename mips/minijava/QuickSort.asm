.data

vmt_QS:
  QS.Start
  QS.Sort
  QS.Print
  QS.Init

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
  la $t9 vmt_QS
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

QS.Start:
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
  li $a0 9999
  jal _print
  lw $t1 8($s0)
  subu $t1 $t1 1
  lw $t0 0($s0)
  lw $t0 4($t0)
  move $a0 $s0
  li $a1 0
  move $a2 $t1
  jalr $t0
  lw $t0 0($s0)
  lw $t0 8($t0)
  move $a0 $s0
  jalr $t0
  li $v0 0
  lw $s0 0($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 12
  jr $ra

QS.Sort:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 20
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  move $s0 $a0
  move $t0 $a1
  move $s1 $a2
  li $t1 0
  slt $t2 $t0 $s1
  beqz $t2 if1_else
  lw $t2 4($s0)
  bnez $t2 null2
  la $a0 _str0
  j _error
null2:
  lw $t3 0($t2)
  sltu $t3 $s1 $t3
  bnez $t3 bounds1
  la $a0 _str1
  j _error
bounds1:
  mul $t3 $s1 4
  addu $t3 $t3 $t2
  lw $t3 4($t3)
  subu $s2 $t0 1
  move $t2 $s1
  li $t4 1
while1_top:
  beqz $t4 while1_end
  li $t5 1
while2_top:
  beqz $t5 while2_end
  addu $s2 $s2 1
  lw $t6 4($s0)
  bnez $t6 null3
  la $a0 _str0
  j _error
null3:
  lw $t7 0($t6)
  sltu $t7 $s2 $t7
  bnez $t7 bounds2
  la $a0 _str1
  j _error
bounds2:
  mul $t7 $s2 4
  addu $t7 $t7 $t6
  lw $t7 4($t7)
  slt $t6 $t7 $t3
  li $t9 1
  subu $t6 $t9 $t6
  beqz $t6 if2_else
  li $t5 0
  j if2_end
if2_else:
  li $t5 1
if2_end:
  j while2_top
while2_end:
  li $t5 1
while3_top:
  beqz $t5 while3_end
  subu $t2 $t2 1
  lw $t6 4($s0)
  bnez $t6 null4
  la $a0 _str0
  j _error
null4:
  lw $t8 0($t6)
  sltu $t8 $t2 $t8
  bnez $t8 bounds3
  la $a0 _str1
  j _error
bounds3:
  mul $t8 $t2 4
  addu $t8 $t8 $t6
  lw $t7 4($t8)
  slt $t7 $t3 $t7
  li $t9 1
  subu $t7 $t9 $t7
  beqz $t7 if3_else
  li $t5 0
  j if3_end
if3_else:
  li $t5 1
if3_end:
  j while3_top
while3_end:
  lw $t5 4($s0)
  bnez $t5 null5
  la $a0 _str0
  j _error
null5:
  lw $t7 0($t5)
  sltu $t7 $s2 $t7
  bnez $t7 bounds4
  la $a0 _str1
  j _error
bounds4:
  mul $t7 $s2 4
  addu $t7 $t7 $t5
  lw $t1 4($t7)
  lw $t7 4($s0)
  bnez $t7 null6
  la $a0 _str0
  j _error
null6:
  lw $t5 0($t7)
  sltu $t5 $s2 $t5
  bnez $t5 bounds5
  la $a0 _str1
  j _error
bounds5:
  mul $t5 $s2 4
  addu $t5 $t5 $t7
  lw $t7 4($s0)
  bnez $t7 null7
  la $a0 _str0
  j _error
null7:
  lw $t8 0($t7)
  sltu $t8 $t2 $t8
  bnez $t8 bounds6
  la $a0 _str1
  j _error
bounds6:
  mul $t8 $t2 4
  addu $t8 $t8 $t7
  lw $t8 4($t8)
  sw $t8 4($t5)
  lw $t8 4($s0)
  bnez $t8 null8
  la $a0 _str0
  j _error
null8:
  lw $t5 0($t8)
  sltu $t5 $t2 $t5
  bnez $t5 bounds7
  la $a0 _str1
  j _error
bounds7:
  mul $t5 $t2 4
  addu $t5 $t5 $t8
  sw $t1 4($t5)
  addu $t5 $s2 1
  slt $t5 $t2 $t5
  beqz $t5 if4_else
  li $t4 0
  j if4_end
if4_else:
  li $t4 1
if4_end:
  j while1_top
while1_end:
  lw $t4 4($s0)
  bnez $t4 null9
  la $a0 _str0
  j _error
null9:
  lw $t3 0($t4)
  sltu $t3 $t2 $t3
  bnez $t3 bounds8
  la $a0 _str1
  j _error
bounds8:
  mul $t3 $t2 4
  addu $t3 $t3 $t4
  lw $t4 4($s0)
  bnez $t4 null10
  la $a0 _str0
  j _error
null10:
  lw $t2 0($t4)
  sltu $t2 $s2 $t2
  bnez $t2 bounds9
  la $a0 _str1
  j _error
bounds9:
  mul $t2 $s2 4
  addu $t2 $t2 $t4
  lw $t2 4($t2)
  sw $t2 4($t3)
  lw $t2 4($s0)
  bnez $t2 null11
  la $a0 _str0
  j _error
null11:
  lw $t3 0($t2)
  sltu $t3 $s2 $t3
  bnez $t3 bounds10
  la $a0 _str1
  j _error
bounds10:
  mul $t3 $s2 4
  addu $t3 $t3 $t2
  lw $t2 4($s0)
  bnez $t2 null12
  la $a0 _str0
  j _error
null12:
  lw $t4 0($t2)
  sltu $t4 $s1 $t4
  bnez $t4 bounds11
  la $a0 _str1
  j _error
bounds11:
  mul $t4 $s1 4
  addu $t4 $t4 $t2
  lw $t4 4($t4)
  sw $t4 4($t3)
  lw $t4 4($s0)
  bnez $t4 null13
  la $a0 _str0
  j _error
null13:
  lw $t3 0($t4)
  sltu $t3 $s1 $t3
  bnez $t3 bounds12
  la $a0 _str1
  j _error
bounds12:
  mul $t3 $s1 4
  addu $t3 $t3 $t4
  sw $t1 4($t3)
  lw $t3 0($s0)
  lw $t3 4($t3)
  subu $t1 $s2 1
  move $a0 $s0
  move $a1 $t0
  move $a2 $t1
  jalr $t3
  lw $t1 0($s0)
  lw $t1 4($t1)
  addu $t3 $s2 1
  move $a0 $s0
  move $a1 $t3
  move $a2 $s1
  jalr $t1
  j if1_end
if1_else:
if1_end:
  li $v0 0
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 20
  jr $ra

QS.Print:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  li $t1 0
while4_top:
  lw $t2 8($t0)
  slt $t2 $t1 $t2
  beqz $t2 while4_end
  lw $t2 4($t0)
  bnez $t2 null14
  la $a0 _str0
  j _error
null14:
  lw $t3 0($t2)
  sltu $t3 $t1 $t3
  bnez $t3 bounds13
  la $a0 _str1
  j _error
bounds13:
  mul $t3 $t1 4
  addu $t3 $t3 $t2
  lw $t3 4($t3)
  move $a0 $t3
  jal _print
  addu $t1 $t1 1
  j while4_top
while4_end:
  li $v0 0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

QS.Init:
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
  bnez $t0 null15
  la $a0 _str0
  j _error
null15:
  lw $t1 0($t0)
  li $t9 0
  sltu $t1 $t9 $t1
  bnez $t1 bounds14
  la $a0 _str1
  j _error
bounds14:
  li $t1 0
  addu $t1 $t1 $t0
  li $t9 20
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null16
  la $a0 _str0
  j _error
null16:
  lw $t0 0($t1)
  li $t9 1
  sltu $t0 $t9 $t0
  bnez $t0 bounds15
  la $a0 _str1
  j _error
bounds15:
  li $t0 4
  addu $t0 $t0 $t1
  li $t9 7
  sw $t9 4($t0)
  lw $t0 4($s0)
  bnez $t0 null17
  la $a0 _str0
  j _error
null17:
  lw $t1 0($t0)
  li $t9 2
  sltu $t1 $t9 $t1
  bnez $t1 bounds16
  la $a0 _str1
  j _error
bounds16:
  li $t1 8
  addu $t1 $t1 $t0
  li $t9 12
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null18
  la $a0 _str0
  j _error
null18:
  lw $t0 0($t1)
  li $t9 3
  sltu $t0 $t9 $t0
  bnez $t0 bounds17
  la $a0 _str1
  j _error
bounds17:
  li $t0 12
  addu $t0 $t0 $t1
  li $t9 18
  sw $t9 4($t0)
  lw $t0 4($s0)
  bnez $t0 null19
  la $a0 _str0
  j _error
null19:
  lw $t1 0($t0)
  li $t9 4
  sltu $t1 $t9 $t1
  bnez $t1 bounds18
  la $a0 _str1
  j _error
bounds18:
  li $t1 16
  addu $t1 $t1 $t0
  li $t9 2
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null20
  la $a0 _str0
  j _error
null20:
  lw $t0 0($t1)
  li $t9 5
  sltu $t0 $t9 $t0
  bnez $t0 bounds19
  la $a0 _str1
  j _error
bounds19:
  li $t0 20
  addu $t0 $t0 $t1
  li $t9 11
  sw $t9 4($t0)
  lw $t0 4($s0)
  bnez $t0 null21
  la $a0 _str0
  j _error
null21:
  lw $t1 0($t0)
  li $t9 6
  sltu $t1 $t9 $t1
  bnez $t1 bounds20
  la $a0 _str1
  j _error
bounds20:
  li $t1 24
  addu $t1 $t1 $t0
  li $t9 6
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null22
  la $a0 _str0
  j _error
null22:
  lw $t0 0($t1)
  li $t9 7
  sltu $t0 $t9 $t0
  bnez $t0 bounds21
  la $a0 _str1
  j _error
bounds21:
  li $t0 28
  addu $t0 $t0 $t1
  li $t9 9
  sw $t9 4($t0)
  lw $t0 4($s0)
  bnez $t0 null23
  la $a0 _str0
  j _error
null23:
  lw $t1 0($t0)
  li $t9 8
  sltu $t1 $t9 $t1
  bnez $t1 bounds22
  la $a0 _str1
  j _error
bounds22:
  li $t1 32
  addu $t1 $t1 $t0
  li $t9 19
  sw $t9 4($t1)
  lw $t1 4($s0)
  bnez $t1 null24
  la $a0 _str0
  j _error
null24:
  lw $t0 0($t1)
  li $t9 9
  sltu $t0 $t9 $t0
  bnez $t0 bounds23
  la $a0 _str1
  j _error
bounds23:
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
