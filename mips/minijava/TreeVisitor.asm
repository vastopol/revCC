.data

vmt_TV:
  TV.Start

vmt_Tree:
  Tree.Init
  Tree.SetRight
  Tree.SetLeft
  Tree.GetRight
  Tree.GetLeft
  Tree.GetKey
  Tree.SetKey
  Tree.GetHas_Right
  Tree.GetHas_Left
  Tree.SetHas_Left
  Tree.SetHas_Right
  Tree.Compare
  Tree.Insert
  Tree.Delete
  Tree.Remove
  Tree.RemoveRight
  Tree.RemoveLeft
  Tree.Search
  Tree.Print
  Tree.RecPrint
  Tree.accept

vmt_Visitor:
  Visitor.visit

vmt_MyVisitor:
  MyVisitor.visit

.text

  jal Main
  li $v0 10
  syscall

Main:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  li $a0 4
  jal _heapAlloc
  move $t0 $v0
  la $t9 vmt_TV
  sw $t9 0($t0)
  bnez $t0 null1
  la $a0 _str0
  j _error
null1:
  lw $t1 0($t0)
  lw $t1 0($t1)
  move $a0 $t0
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

TV.Start:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 12
  sw $ra -4($fp)
  sw $s0 0($sp)
  li $a0 28
  jal _heapAlloc
  move $t0 $v0
  la $t9 vmt_Tree
  sw $t9 0($t0)
  move $s0 $t0
  bnez $s0 null2
  la $a0 _str0
  j _error
null2:
  lw $t0 0($s0)
  lw $t0 0($t0)
  move $a0 $s0
  li $a1 16
  jalr $t0
  bnez $s0 null3
  la $a0 _str0
  j _error
null3:
  lw $t0 0($s0)
  lw $t0 72($t0)
  move $a0 $s0
  jalr $t0
  li $a0 100000000
  jal _print
  bnez $s0 null4
  la $a0 _str0
  j _error
null4:
  lw $t0 0($s0)
  lw $t0 48($t0)
  move $a0 $s0
  li $a1 8
  jalr $t0
  bnez $s0 null5
  la $a0 _str0
  j _error
null5:
  lw $t0 0($s0)
  lw $t0 48($t0)
  move $a0 $s0
  li $a1 24
  jalr $t0
  bnez $s0 null6
  la $a0 _str0
  j _error
null6:
  lw $t0 0($s0)
  lw $t0 48($t0)
  move $a0 $s0
  li $a1 4
  jalr $t0
  bnez $s0 null7
  la $a0 _str0
  j _error
null7:
  lw $t0 0($s0)
  lw $t0 48($t0)
  move $a0 $s0
  li $a1 12
  jalr $t0
  bnez $s0 null8
  la $a0 _str0
  j _error
null8:
  lw $t0 0($s0)
  lw $t0 48($t0)
  move $a0 $s0
  li $a1 20
  jalr $t0
  bnez $s0 null9
  la $a0 _str0
  j _error
null9:
  lw $t0 0($s0)
  lw $t0 48($t0)
  move $a0 $s0
  li $a1 28
  jalr $t0
  bnez $s0 null10
  la $a0 _str0
  j _error
null10:
  lw $t0 0($s0)
  lw $t0 48($t0)
  move $a0 $s0
  li $a1 14
  jalr $t0
  bnez $s0 null11
  la $a0 _str0
  j _error
null11:
  lw $t0 0($s0)
  lw $t0 72($t0)
  move $a0 $s0
  jalr $t0
  li $a0 100000000
  jal _print
  li $a0 12
  jal _heapAlloc
  move $t0 $v0
  la $t9 vmt_MyVisitor
  sw $t9 0($t0)
  move $t0 $t0
  li $a0 50000000
  jal _print
  bnez $s0 null12
  la $a0 _str0
  j _error
null12:
  lw $t1 0($s0)
  lw $t1 80($t1)
  move $a0 $s0
  move $a1 $t0
  jalr $t1
  li $a0 100000000
  jal _print
  bnez $s0 null13
  la $a0 _str0
  j _error
null13:
  lw $t1 0($s0)
  lw $t1 68($t1)
  move $a0 $s0
  li $a1 24
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  bnez $s0 null14
  la $a0 _str0
  j _error
null14:
  lw $t1 0($s0)
  lw $t1 68($t1)
  move $a0 $s0
  li $a1 12
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  bnez $s0 null15
  la $a0 _str0
  j _error
null15:
  lw $t1 0($s0)
  lw $t1 68($t1)
  move $a0 $s0
  li $a1 16
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  bnez $s0 null16
  la $a0 _str0
  j _error
null16:
  lw $t1 0($s0)
  lw $t1 68($t1)
  move $a0 $s0
  li $a1 50
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  bnez $s0 null17
  la $a0 _str0
  j _error
null17:
  lw $t1 0($s0)
  lw $t1 68($t1)
  move $a0 $s0
  li $a1 12
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  bnez $s0 null18
  la $a0 _str0
  j _error
null18:
  lw $t1 0($s0)
  lw $t1 52($t1)
  move $a0 $s0
  li $a1 12
  jalr $t1
  bnez $s0 null19
  la $a0 _str0
  j _error
null19:
  lw $t1 0($s0)
  lw $t1 72($t1)
  move $a0 $s0
  jalr $t1
  bnez $s0 null20
  la $a0 _str0
  j _error
null20:
  lw $t1 0($s0)
  lw $t1 68($t1)
  move $a0 $s0
  li $a1 12
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  li $v0 0
  lw $s0 0($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 12
  jr $ra

Tree.Init:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $a1
  sw $t1 12($t0)
  sw $0 16($t0)
  sw $0 20($t0)
  li $v0 1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.SetRight:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $a1
  sw $t1 8($t0)
  li $v0 1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.SetLeft:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $a1
  sw $t1 4($t0)
  li $v0 1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.GetRight:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  lw $t0 8($t0)
  move $v0 $t0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.GetLeft:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  lw $t0 4($t0)
  move $v0 $t0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.GetKey:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  lw $t0 12($t0)
  move $v0 $t0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.SetKey:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $a1
  sw $t1 12($t0)
  li $v0 1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.GetHas_Right:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  lw $t0 20($t0)
  move $v0 $t0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.GetHas_Left:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  lw $t0 16($t0)
  move $v0 $t0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.SetHas_Left:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $a1
  sw $t1 16($t0)
  li $v0 1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.SetHas_Right:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $a1
  sw $t1 20($t0)
  li $v0 1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.Compare:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a1
  move $t1 $a2
  addu $t2 $t1 1
  slt $t1 $t0 $t1
  beqz $t1 if1_else
  li $t1 0
  j if1_end
if1_else:
  slt $t2 $t0 $t2
  li $t9 1
  subu $t2 $t9 $t2
  beqz $t2 if2_else
  li $t1 0
  j if2_end
if2_else:
  li $t1 1
if2_end:
if1_end:
  move $v0 $t1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.Insert:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 24
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  sw $s3 12($sp)
  move $s0 $a0
  move $s1 $a1
  li $a0 28
  jal _heapAlloc
  move $t0 $v0
  la $t9 vmt_Tree
  sw $t9 0($t0)
  move $s2 $t0
  bnez $s2 null21
  la $a0 _str0
  j _error
null21:
  lw $t0 0($s2)
  lw $t0 0($t0)
  move $a0 $s2
  move $a1 $s1
  jalr $t0
  move $s0 $s0
  li $s3 1
while1_top:
  beqz $s3 while1_end
  bnez $s0 null22
  la $a0 _str0
  j _error
null22:
  lw $t0 0($s0)
  lw $t0 20($t0)
  move $a0 $s0
  jalr $t0
  move $t0 $v0
  slt $t0 $s1 $t0
  beqz $t0 if3_else
  bnez $s0 null23
  la $a0 _str0
  j _error
null23:
  lw $t0 0($s0)
  lw $t0 32($t0)
  move $a0 $s0
  jalr $t0
  move $t0 $v0
  beqz $t0 if4_else
  bnez $s0 null24
  la $a0 _str0
  j _error
null24:
  lw $t0 0($s0)
  lw $t0 16($t0)
  move $a0 $s0
  jalr $t0
  move $s0 $v0
  j if4_end
if4_else:
  li $s3 0
  bnez $s0 null25
  la $a0 _str0
  j _error
null25:
  lw $t0 0($s0)
  lw $t0 36($t0)
  move $a0 $s0
  li $a1 1
  jalr $t0
  bnez $s0 null26
  la $a0 _str0
  j _error
null26:
  lw $t0 0($s0)
  lw $t0 8($t0)
  move $a0 $s0
  move $a1 $s2
  jalr $t0
if4_end:
  j if3_end
if3_else:
  bnez $s0 null27
  la $a0 _str0
  j _error
null27:
  lw $t0 0($s0)
  lw $t0 28($t0)
  move $a0 $s0
  jalr $t0
  move $t0 $v0
  beqz $t0 if5_else
  bnez $s0 null28
  la $a0 _str0
  j _error
null28:
  lw $t0 0($s0)
  lw $t0 12($t0)
  move $a0 $s0
  jalr $t0
  move $s0 $v0
  j if5_end
if5_else:
  li $s3 0
  bnez $s0 null29
  la $a0 _str0
  j _error
null29:
  lw $t0 0($s0)
  lw $t0 40($t0)
  move $a0 $s0
  li $a1 1
  jalr $t0
  bnez $s0 null30
  la $a0 _str0
  j _error
null30:
  lw $t0 0($s0)
  lw $t0 4($t0)
  move $a0 $s0
  move $a1 $s2
  jalr $t0
if5_end:
if3_end:
  j while1_top
while1_end:
  li $v0 1
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $s3 12($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 24
  jr $ra

Tree.Delete:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 36
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  sw $s3 12($sp)
  sw $s4 16($sp)
  sw $s5 20($sp)
  sw $s6 24($sp)
  move $s0 $a0
  move $s1 $a1
  move $s2 $s0
  move $s3 $s0
  li $s4 1
  li $s5 0
  li $s6 1
while2_top:
  beqz $s4 while2_end
  bnez $s2 null31
  la $a0 _str0
  j _error
null31:
  lw $t0 0($s2)
  lw $t0 20($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  slt $t1 $s1 $t0
  beqz $t1 if6_else
  bnez $s2 null32
  la $a0 _str0
  j _error
null32:
  lw $t1 0($s2)
  lw $t1 32($t1)
  move $a0 $s2
  jalr $t1
  move $t1 $v0
  beqz $t1 if7_else
  move $s3 $s2
  bnez $s2 null33
  la $a0 _str0
  j _error
null33:
  lw $t1 0($s2)
  lw $t1 16($t1)
  move $a0 $s2
  jalr $t1
  move $s2 $v0
  j if7_end
if7_else:
  li $s4 0
if7_end:
  j if6_end
if6_else:
  slt $t0 $t0 $s1
  beqz $t0 if8_else
  bnez $s2 null34
  la $a0 _str0
  j _error
null34:
  lw $t0 0($s2)
  lw $t0 28($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  beqz $t0 if9_else
  move $s3 $s2
  bnez $s2 null35
  la $a0 _str0
  j _error
null35:
  lw $t0 0($s2)
  lw $t0 12($t0)
  move $a0 $s2
  jalr $t0
  move $s2 $v0
  j if9_end
if9_else:
  li $s4 0
if9_end:
  j if8_end
if8_else:
  beqz $s6 if10_else
  bnez $s2 null36
  la $a0 _str0
  j _error
null36:
  lw $t0 0($s2)
  lw $t0 28($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  li $t9 1
  subu $t0 $t9 $t0
  beqz $t0 ss1_else
  bnez $s2 null37
  la $a0 _str0
  j _error
null37:
  lw $t0 0($s2)
  lw $t0 32($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  li $t9 1
  subu $t0 $t9 $t0
  j ss1_end
ss1_else:
  li $t0 0
ss1_end:
  beqz $t0 if11_else
  j if11_end
if11_else:
  lw $t0 0($s0)
  lw $t0 56($t0)
  move $a0 $s0
  move $a1 $s3
  move $a2 $s2
  jalr $t0
if11_end:
  j if10_end
if10_else:
  lw $t0 0($s0)
  lw $t0 56($t0)
  move $a0 $s0
  move $a1 $s3
  move $a2 $s2
  jalr $t0
if10_end:
  li $s5 1
  li $s4 0
if8_end:
if6_end:
  li $s6 0
  j while2_top
while2_end:
  move $v0 $s5
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $s3 12($sp)
  lw $s4 16($sp)
  lw $s5 20($sp)
  lw $s6 24($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 36
  jr $ra

Tree.Remove:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 20
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  move $s0 $a0
  move $s1 $a1
  move $s2 $a2
  bnez $s2 null38
  la $a0 _str0
  j _error
null38:
  lw $t0 0($s2)
  lw $t0 32($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  beqz $t0 if12_else
  lw $t0 0($s0)
  lw $t0 64($t0)
  move $a0 $s0
  move $a1 $s1
  move $a2 $s2
  jalr $t0
  j if12_end
if12_else:
  bnez $s2 null39
  la $a0 _str0
  j _error
null39:
  lw $t0 0($s2)
  lw $t0 28($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  beqz $t0 if13_else
  lw $t0 0($s0)
  lw $t0 60($t0)
  move $a0 $s0
  move $a1 $s1
  move $a2 $s2
  jalr $t0
  j if13_end
if13_else:
  bnez $s2 null40
  la $a0 _str0
  j _error
null40:
  lw $t0 0($s2)
  lw $t0 20($t0)
  move $a0 $s2
  jalr $t0
  move $s2 $v0
  bnez $s1 null41
  la $a0 _str0
  j _error
null41:
  lw $t0 0($s1)
  lw $t0 16($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  bnez $t0 null42
  la $a0 _str0
  j _error
null42:
  lw $t1 0($t0)
  lw $t1 20($t1)
  move $a0 $t0
  jalr $t1
  move $t1 $v0
  lw $t0 0($s0)
  lw $t0 44($t0)
  move $a0 $s0
  move $a1 $s2
  move $a2 $t1
  jalr $t0
  move $t0 $v0
  beqz $t0 if14_else
  bnez $s1 null43
  la $a0 _str0
  j _error
null43:
  lw $t0 0($s1)
  lw $t0 8($t0)
  lw $t1 24($s0)
  move $a0 $s1
  move $a1 $t1
  jalr $t0
  bnez $s1 null44
  la $a0 _str0
  j _error
null44:
  lw $t1 0($s1)
  lw $t1 36($t1)
  move $a0 $s1
  li $a1 0
  jalr $t1
  j if14_end
if14_else:
  bnez $s1 null45
  la $a0 _str0
  j _error
null45:
  lw $t1 0($s1)
  lw $t1 4($t1)
  lw $t0 24($s0)
  move $a0 $s1
  move $a1 $t0
  jalr $t1
  bnez $s1 null46
  la $a0 _str0
  j _error
null46:
  lw $t0 0($s1)
  lw $t0 40($t0)
  move $a0 $s1
  li $a1 0
  jalr $t0
if14_end:
if13_end:
if12_end:
  li $v0 1
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 20
  jr $ra

Tree.RemoveRight:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 24
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  sw $s3 12($sp)
  move $s0 $a0
  move $s1 $a1
  move $s2 $a2
while3_top:
  bnez $s2 null47
  la $a0 _str0
  j _error
null47:
  lw $t0 0($s2)
  lw $t0 28($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  beqz $t0 while3_end
  bnez $s2 null48
  la $a0 _str0
  j _error
null48:
  lw $s3 0($s2)
  lw $s3 24($s3)
  bnez $s2 null49
  la $a0 _str0
  j _error
null49:
  lw $t0 0($s2)
  lw $t0 12($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  bnez $t0 null50
  la $a0 _str0
  j _error
null50:
  lw $t1 0($t0)
  lw $t1 20($t1)
  move $a0 $t0
  jalr $t1
  move $t1 $v0
  move $a0 $s2
  move $a1 $t1
  jalr $s3
  move $s1 $s2
  bnez $s2 null51
  la $a0 _str0
  j _error
null51:
  lw $t1 0($s2)
  lw $t1 12($t1)
  move $a0 $s2
  jalr $t1
  move $s2 $v0
  j while3_top
while3_end:
  bnez $s1 null52
  la $a0 _str0
  j _error
null52:
  lw $t1 0($s1)
  lw $t1 4($t1)
  lw $t0 24($s0)
  move $a0 $s1
  move $a1 $t0
  jalr $t1
  bnez $s1 null53
  la $a0 _str0
  j _error
null53:
  lw $t0 0($s1)
  lw $t0 40($t0)
  move $a0 $s1
  li $a1 0
  jalr $t0
  li $v0 1
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $s3 12($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 24
  jr $ra

Tree.RemoveLeft:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 24
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  sw $s3 12($sp)
  move $s0 $a0
  move $s1 $a1
  move $s2 $a2
while4_top:
  bnez $s2 null54
  la $a0 _str0
  j _error
null54:
  lw $t0 0($s2)
  lw $t0 32($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  beqz $t0 while4_end
  bnez $s2 null55
  la $a0 _str0
  j _error
null55:
  lw $s3 0($s2)
  lw $s3 24($s3)
  bnez $s2 null56
  la $a0 _str0
  j _error
null56:
  lw $t0 0($s2)
  lw $t0 16($t0)
  move $a0 $s2
  jalr $t0
  move $t0 $v0
  bnez $t0 null57
  la $a0 _str0
  j _error
null57:
  lw $t1 0($t0)
  lw $t1 20($t1)
  move $a0 $t0
  jalr $t1
  move $t1 $v0
  move $a0 $s2
  move $a1 $t1
  jalr $s3
  move $s1 $s2
  bnez $s2 null58
  la $a0 _str0
  j _error
null58:
  lw $t1 0($s2)
  lw $t1 16($t1)
  move $a0 $s2
  jalr $t1
  move $s2 $v0
  j while4_top
while4_end:
  bnez $s1 null59
  la $a0 _str0
  j _error
null59:
  lw $t1 0($s1)
  lw $t1 8($t1)
  lw $t0 24($s0)
  move $a0 $s1
  move $a1 $t0
  jalr $t1
  bnez $s1 null60
  la $a0 _str0
  j _error
null60:
  lw $t0 0($s1)
  lw $t0 36($t0)
  move $a0 $s1
  li $a1 0
  jalr $t0
  li $v0 1
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $s3 12($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 24
  jr $ra

Tree.Search:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 24
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  sw $s3 12($sp)
  move $t0 $a0
  move $s0 $a1
  move $s1 $t0
  li $s2 1
  li $s3 0
while5_top:
  beqz $s2 while5_end
  bnez $s1 null61
  la $a0 _str0
  j _error
null61:
  lw $t0 0($s1)
  lw $t0 20($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  slt $t1 $s0 $t0
  beqz $t1 if15_else
  bnez $s1 null62
  la $a0 _str0
  j _error
null62:
  lw $t1 0($s1)
  lw $t1 32($t1)
  move $a0 $s1
  jalr $t1
  move $t1 $v0
  beqz $t1 if16_else
  bnez $s1 null63
  la $a0 _str0
  j _error
null63:
  lw $t1 0($s1)
  lw $t1 16($t1)
  move $a0 $s1
  jalr $t1
  move $s1 $v0
  j if16_end
if16_else:
  li $s2 0
if16_end:
  j if15_end
if15_else:
  slt $t0 $t0 $s0
  beqz $t0 if17_else
  bnez $s1 null64
  la $a0 _str0
  j _error
null64:
  lw $t0 0($s1)
  lw $t0 28($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  beqz $t0 if18_else
  bnez $s1 null65
  la $a0 _str0
  j _error
null65:
  lw $t0 0($s1)
  lw $t0 12($t0)
  move $a0 $s1
  jalr $t0
  move $s1 $v0
  j if18_end
if18_else:
  li $s2 0
if18_end:
  j if17_end
if17_else:
  li $s3 1
  li $s2 0
if17_end:
if15_end:
  j while5_top
while5_end:
  move $v0 $s3
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $s3 12($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 24
  jr $ra

Tree.Print:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $t0
  lw $t2 0($t0)
  lw $t2 76($t2)
  move $a0 $t0
  move $a1 $t1
  jalr $t2
  li $v0 1
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Tree.RecPrint:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 20
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  sw $s2 8($sp)
  move $s0 $a0
  move $s1 $a1
  bnez $s1 null66
  la $a0 _str0
  j _error
null66:
  lw $t0 0($s1)
  lw $t0 32($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  beqz $t0 if19_else
  lw $s2 0($s0)
  lw $s2 76($s2)
  bnez $s1 null67
  la $a0 _str0
  j _error
null67:
  lw $t0 0($s1)
  lw $t0 16($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  move $a0 $s0
  move $a1 $t0
  jalr $s2
  j if19_end
if19_else:
if19_end:
  bnez $s1 null68
  la $a0 _str0
  j _error
null68:
  lw $t0 0($s1)
  lw $t0 20($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  move $a0 $t0
  jal _print
  bnez $s1 null69
  la $a0 _str0
  j _error
null69:
  lw $t0 0($s1)
  lw $t0 28($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  beqz $t0 if20_else
  lw $s2 0($s0)
  lw $s2 76($s2)
  bnez $s1 null70
  la $a0 _str0
  j _error
null70:
  lw $t0 0($s1)
  lw $t0 12($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  move $a0 $s0
  move $a1 $t0
  jalr $s2
  j if20_end
if20_else:
if20_end:
  li $v0 1
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $s2 8($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 20
  jr $ra

Tree.accept:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 8
  sw $ra -4($fp)
  move $t0 $a0
  move $t1 $a1
  li $a0 333
  jal _print
  bnez $t1 null71
  la $a0 _str0
  j _error
null71:
  lw $t2 0($t1)
  lw $t2 0($t2)
  move $a0 $t1
  move $a1 $t0
  jalr $t2
  li $v0 0
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 8
  jr $ra

Visitor.visit:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 16
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  move $s0 $a0
  move $s1 $a1
  bnez $s1 null72
  la $a0 _str0
  j _error
null72:
  lw $t0 0($s1)
  lw $t0 28($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  beqz $t0 if21_else
  bnez $s1 null73
  la $a0 _str0
  j _error
null73:
  lw $t0 0($s1)
  lw $t0 12($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  sw $t0 8($s0)
  lw $t0 8($s0)
  bnez $t0 null74
  la $a0 _str0
  j _error
null74:
  lw $t1 0($t0)
  lw $t1 80($t1)
  move $a0 $t0
  move $a1 $s0
  jalr $t1
  j if21_end
if21_else:
if21_end:
  bnez $s1 null75
  la $a0 _str0
  j _error
null75:
  lw $t1 0($s1)
  lw $t1 32($t1)
  move $a0 $s1
  jalr $t1
  move $t1 $v0
  beqz $t1 if22_else
  bnez $s1 null76
  la $a0 _str0
  j _error
null76:
  lw $t1 0($s1)
  lw $t1 16($t1)
  move $a0 $s1
  jalr $t1
  move $t1 $v0
  sw $t1 4($s0)
  lw $t1 4($s0)
  bnez $t1 null77
  la $a0 _str0
  j _error
null77:
  lw $t0 0($t1)
  lw $t0 80($t0)
  move $a0 $t1
  move $a1 $s0
  jalr $t0
  j if22_end
if22_else:
if22_end:
  li $v0 0
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 16
  jr $ra

MyVisitor.visit:
  sw $fp -8($sp)
  move $fp $sp
  subu $sp $sp 16
  sw $ra -4($fp)
  sw $s0 0($sp)
  sw $s1 4($sp)
  move $s0 $a0
  move $s1 $a1
  bnez $s1 null78
  la $a0 _str0
  j _error
null78:
  lw $t0 0($s1)
  lw $t0 28($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  beqz $t0 if23_else
  bnez $s1 null79
  la $a0 _str0
  j _error
null79:
  lw $t0 0($s1)
  lw $t0 12($t0)
  move $a0 $s1
  jalr $t0
  move $t0 $v0
  sw $t0 8($s0)
  lw $t0 8($s0)
  bnez $t0 null80
  la $a0 _str0
  j _error
null80:
  lw $t1 0($t0)
  lw $t1 80($t1)
  move $a0 $t0
  move $a1 $s0
  jalr $t1
  j if23_end
if23_else:
if23_end:
  bnez $s1 null81
  la $a0 _str0
  j _error
null81:
  lw $t1 0($s1)
  lw $t1 20($t1)
  move $a0 $s1
  jalr $t1
  move $t1 $v0
  move $a0 $t1
  jal _print
  bnez $s1 null82
  la $a0 _str0
  j _error
null82:
  lw $t1 0($s1)
  lw $t1 32($t1)
  move $a0 $s1
  jalr $t1
  move $t1 $v0
  beqz $t1 if24_else
  bnez $s1 null83
  la $a0 _str0
  j _error
null83:
  lw $t1 0($s1)
  lw $t1 16($t1)
  move $a0 $s1
  jalr $t1
  move $t1 $v0
  sw $t1 4($s0)
  lw $t1 4($s0)
  bnez $t1 null84
  la $a0 _str0
  j _error
null84:
  lw $t0 0($t1)
  lw $t0 80($t0)
  move $a0 $t1
  move $a1 $s0
  jalr $t0
  j if24_end
if24_else:
if24_end:
  li $v0 0
  lw $s0 0($sp)
  lw $s1 4($sp)
  lw $ra -4($fp)
  lw $fp -8($fp)
  addu $sp $sp 16
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
