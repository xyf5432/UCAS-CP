.data

.text
.globl main
.type main, @function

ifElseIf:
  # Function Prologue for ifElseIf
  addi sp, sp, -144
  sw   ra, 140(sp)
  sw   s0, 136(sp)
  addi s0, sp, 144
.ifElseIf_entry:
  #   %b = alloca i32
  #   %a = alloca i32
  #   store i32 0, i32* %a
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 5, i32* %a
  addi t1, s0, -52
  lui  t0, 0
  addi t0, t0, 5
  sw   t0, 0(t1)
  #   store i32 0, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 10, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 10
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %eqtmp = icmp eq i32 %a.val, 6
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 6
  li   t2, 0
  bne t0, t1, .ifElseIf_skip94677805439104
  li   t2, 1
.ifElseIf_skip94677805439104:
  sw   t2, -60(s0)
  #   br i1 %eqtmp, label %or.end, label %or.rhs
  lw   t0, -60(s0)
  beqz t0, .entry_br_false_path_94677805471928
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -72(s0)
  j .ifElseIf_or.end
.entry_br_false_path_94677805471928:
  j .ifElseIf_or.rhs
.ifElseIf_or.rhs:
  #   %b.val = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %eqtmp1 = icmp eq i32 %b.val, 11
  lw   t0, -64(s0)
  lui  t1, 0
  addi t1, t1, 11
  li   t2, 0
  bne t0, t1, .ifElseIf_skip94677805439216
  li   t2, 1
.ifElseIf_skip94677805439216:
  sw   t2, -68(s0)
  #   br label %or.end
  lw   t2, -68(s0)
  sw   t2, -72(s0)
  j .ifElseIf_or.end
.ifElseIf_or.end:
  #   %or.result = phi i1 [ true, %entry ], [ %eqtmp1, %or.rhs ]
  #   br i1 %or.result, label %if.then, label %if.else
  lw   t0, -72(s0)
  beqz t0, .or.end_br_false_path_94677805473400
  j .ifElseIf_if.then
.or.end_br_false_path_94677805473400:
  j .ifElseIf_if.else
.ifElseIf_if.then:
  #   %a.val2 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -76(s0)
  #   ret i32 %a.val2
  lw   a0, -76(s0)
  j    .ifElseIf_epilogue
  #   br label %if.merge
  j .ifElseIf_if.merge
.ifElseIf_if.else:
  #   %b.val3 = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -80(s0)
  #   %eqtmp4 = icmp eq i32 %b.val3, 10
  lw   t0, -80(s0)
  lui  t1, 0
  addi t1, t1, 10
  li   t2, 0
  bne t0, t1, .ifElseIf_skip94677805439488
  li   t2, 1
.ifElseIf_skip94677805439488:
  sw   t2, -84(s0)
  #   br i1 %eqtmp4, label %and.rhs, label %and.end
  lw   t0, -84(s0)
  beqz t0, .if.else_br_false_path_94677805479688
  j .ifElseIf_and.rhs
.if.else_br_false_path_94677805479688:
  lui  t2, 0
  sw   t2, -100(s0)
  j .ifElseIf_and.end
.ifElseIf_if.merge:
  #   %a.val22 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -88(s0)
  #   ret i32 %a.val22
  lw   a0, -88(s0)
  j    .ifElseIf_epilogue
.ifElseIf_and.rhs:
  #   %a.val5 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -92(s0)
  #   %eqtmp6 = icmp eq i32 %a.val5, 1
  lw   t0, -92(s0)
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 0
  bne t0, t1, .ifElseIf_skip94677805415136
  li   t2, 1
.ifElseIf_skip94677805415136:
  sw   t2, -96(s0)
  #   br label %and.end
  lw   t2, -96(s0)
  sw   t2, -100(s0)
  j .ifElseIf_and.end
.ifElseIf_and.end:
  #   %and.result = phi i1 [ false, %if.else ], [ %eqtmp6, %and.rhs ]
  #   br i1 %and.result, label %if.then7, label %if.else8
  lw   t0, -100(s0)
  beqz t0, .and.end_br_false_path_94677805480680
  j .ifElseIf_if.then7
.and.end_br_false_path_94677805480680:
  j .ifElseIf_if.else8
.ifElseIf_if.then7:
  #   store i32 25, i32* %a
  addi t1, s0, -52
  lui  t0, 0
  addi t0, t0, 25
  sw   t0, 0(t1)
  #   br label %if.merge9
  j .ifElseIf_if.merge9
.ifElseIf_if.else8:
  #   %b.val10 = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -104(s0)
  #   %eqtmp11 = icmp eq i32 %b.val10, 10
  lw   t0, -104(s0)
  lui  t1, 0
  addi t1, t1, 10
  li   t2, 0
  bne t0, t1, .ifElseIf_skip94677805439600
  li   t2, 1
.ifElseIf_skip94677805439600:
  sw   t2, -108(s0)
  #   br i1 %eqtmp11, label %and.rhs12, label %and.end13
  lw   t0, -108(s0)
  beqz t0, .if.else8_br_false_path_94677805482312
  j .ifElseIf_and.rhs12
.if.else8_br_false_path_94677805482312:
  lui  t2, 0
  sw   t2, -120(s0)
  j .ifElseIf_and.end13
.ifElseIf_if.merge9:
  #   br label %if.merge
  j .ifElseIf_if.merge
.ifElseIf_and.rhs12:
  #   %a.val14 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -112(s0)
  #   %eqtmp15 = icmp eq i32 %a.val14, -5
  lw   t0, -112(s0)
  lui  t1, 0
  addi t1, t1, -5
  li   t2, 0
  bne t0, t1, .ifElseIf_skip94677805482608
  li   t2, 1
.ifElseIf_skip94677805482608:
  sw   t2, -116(s0)
  #   br label %and.end13
  lw   t2, -116(s0)
  sw   t2, -120(s0)
  j .ifElseIf_and.end13
.ifElseIf_and.end13:
  #   %and.result16 = phi i1 [ false, %if.else8 ], [ %eqtmp15, %and.rhs12 ]
  #   br i1 %and.result16, label %if.then17, label %if.else18
  lw   t0, -120(s0)
  beqz t0, .and.end13_br_false_path_94677805483464
  j .ifElseIf_if.then17
.and.end13_br_false_path_94677805483464:
  j .ifElseIf_if.else18
.ifElseIf_if.then17:
  #   %a.val20 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -124(s0)
  #   %add_tmp = add i32 %a.val20, 15
  lw   t0, -124(s0)
  lui  t1, 0
  addi t1, t1, 15
  add t2, t0, t1
  sw   t2, -128(s0)
  #   store i32 %add_tmp, i32* %a
  addi t1, s0, -52
  lw   t0, -128(s0)
  sw   t0, 0(t1)
  #   br label %if.merge19
  j .ifElseIf_if.merge19
.ifElseIf_if.else18:
  #   %a.val21 = load i32, i32* %a
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -132(s0)
  #   %neg = sub i32 0, %a.val21
  lui  t0, 0
  lw   t1, -132(s0)
  sub t2, t0, t1
  sw   t2, -136(s0)
  #   store i32 %neg, i32* %a
  addi t1, s0, -52
  lw   t0, -136(s0)
  sw   t0, 0(t1)
  #   br label %if.merge19
  j .ifElseIf_if.merge19
.ifElseIf_if.merge19:
  #   br label %if.merge9
  j .ifElseIf_if.merge9
.ifElseIf_epilogue:
  # Function Epilogue for ifElseIf
  lw   ra, 140(sp)
  lw   s0, 136(sp)
  addi sp, sp, 144
  ret

main:
  # Function Prologue for main
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
.main_entry:
  #   %calltmp = call i32 @ifElseIf()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call ifElseIf
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -48(s0)
  #   call void @print_int(i32 %calltmp)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -48(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   ret i32 0
  lui  a0, 0
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
