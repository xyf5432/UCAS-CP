.data

.text
.globl main
.type main, @function

whileIf:
  # Function Prologue for whileIf
  addi sp, sp, -112
  sw   ra, 108(sp)
  sw   s0, 104(sp)
  addi s0, sp, 112
.whileIf_entry:
  #   %b = alloca i32
  #   %a = alloca i32
  #   store i32 0, i32* %a
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %a
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %while.cond
  j .whileIf_while.cond
.whileIf_while.cond:
  #   %a.val = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %cmptmp = icmp slt i32 %a.val, 100
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 100
  li   t2, 0
  bge t0, t1, .whileIf_skip94745357678464
  li   t2, 1
.whileIf_skip94745357678464:
  sw   t2, -60(s0)
  #   br i1 %cmptmp, label %while.body, label %while.end
  lw   t0, -60(s0)
  beqz t0, .while.cond_br_false_path_94745357708472
  j .whileIf_while.body
.while.cond_br_false_path_94745357708472:
  j .whileIf_while.end
.whileIf_while.body:
  #   %a.val1 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %eqtmp = icmp eq i32 %a.val1, 5
  lw   t0, -64(s0)
  lui  t1, 0
  addi t1, t1, 5
  li   t2, 0
  bne t0, t1, .whileIf_skip94745357667392
  li   t2, 1
.whileIf_skip94745357667392:
  sw   t2, -68(s0)
  #   br i1 %eqtmp, label %if.then, label %if.else
  lw   t0, -68(s0)
  beqz t0, .while.body_br_false_path_94745357710440
  j .whileIf_if.then
.while.body_br_false_path_94745357710440:
  j .whileIf_if.else
.whileIf_if.then:
  #   store i32 25, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 25
  sw   t0, 0(t1)
  #   br label %if.merge
  j .whileIf_if.merge
.whileIf_if.else:
  #   %a.val2 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   %eqtmp3 = icmp eq i32 %a.val2, 10
  lw   t0, -72(s0)
  lui  t1, 0
  addi t1, t1, 10
  li   t2, 0
  bne t0, t1, .whileIf_skip94745357668432
  li   t2, 1
.whileIf_skip94745357668432:
  sw   t2, -76(s0)
  #   br i1 %eqtmp3, label %if.then4, label %if.else5
  lw   t0, -76(s0)
  beqz t0, .if.else_br_false_path_94745357710584
  j .whileIf_if.then4
.if.else_br_false_path_94745357710584:
  j .whileIf_if.else5
.whileIf_if.merge:
  #   %a.val8 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -80(s0)
  #   %add_tmp = add i32 %a.val8, 1
  lw   t0, -80(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -84(s0)
  #   store i32 %add_tmp, i32* %a
  addi t1, s0, -52
  lw   t0, -84(s0)
  sw   t0, 0(t1)
  #   br label %while.cond
  j .whileIf_while.cond
.whileIf_if.then4:
  #   store i32 42, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 42
  sw   t0, 0(t1)
  #   br label %if.merge6
  j .whileIf_if.merge6
.whileIf_if.else5:
  #   %a.val7 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -88(s0)
  #   %mul_tmp = mul i32 %a.val7, 2
  lw   t0, -88(s0)
  lui  t1, 0
  addi t1, t1, 2
  mul t2, t0, t1
  sw   t2, -92(s0)
  #   store i32 %mul_tmp, i32* %b
  addi t1, s0, -48
  lw   t0, -92(s0)
  sw   t0, 0(t1)
  #   br label %if.merge6
  j .whileIf_if.merge6
.whileIf_if.merge6:
  #   br label %if.merge
  j .whileIf_if.merge
.whileIf_while.end:
  #   %b.val = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -96(s0)
  #   ret i32 %b.val
  lw   a0, -96(s0)
  j    .whileIf_epilogue
.whileIf_epilogue:
  # Function Epilogue for whileIf
  lw   ra, 108(sp)
  lw   s0, 104(sp)
  addi sp, sp, 112
  ret

main:
  # Function Prologue for main
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
.main_entry:
  #   %calltmp = call i32 @whileIf()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call whileIf
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -48(s0)
  #   ret i32 %calltmp
  lw   a0, -48(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
