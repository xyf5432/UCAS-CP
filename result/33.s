.data
  .type a, @object
  .size a, 4
a:
  .word -1
  .type b, @object
  .size b, 4
b:
  .word 1

.text
.globl main
.type main, @function

inc_a:
  # Function Prologue for inc_a
  addi sp, sp, -80
  sw   ra, 76(sp)
  sw   s0, 72(sp)
  addi s0, sp, 80
.inc_a_entry:
  #   %b = alloca i32
  #   store i32 0, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -52(s0)
  #   store i32 %a.val, i32* %b
  addi t1, s0, -48
  lw   t0, -52(s0)
  sw   t0, 0(t1)
  #   %b.val = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %add_tmp = add i32 %b.val, 1
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -60(s0)
  #   store i32 %add_tmp, i32* %b
  addi t1, s0, -48
  lw   t0, -60(s0)
  sw   t0, 0(t1)
  #   %b.val1 = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   store i32 %b.val1, i32* @a
  la   t1, a
  lw   t0, -64(s0)
  sw   t0, 0(t1)
  #   %a.val2 = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -68(s0)
  #   ret i32 %a.val2
  lw   a0, -68(s0)
  j    .inc_a_epilogue
.inc_a_epilogue:
  # Function Epilogue for inc_a
  lw   ra, 76(sp)
  lw   s0, 72(sp)
  addi sp, sp, 80
  ret

main:
  # Function Prologue for main
  addi sp, sp, -192
  sw   ra, 188(sp)
  sw   s0, 184(sp)
  addi s0, sp, 192
.main_entry:
  #   %k = alloca i32
  #   store i32 5, i32* %k
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 5
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_while.cond:
  #   %k.val = load i32, i32* %k
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -52(s0)
  #   %cmptmp = icmp sge i32 %k.val, 0
  lw   t0, -52(s0)
  lui  t1, 0
  li   t2, 0
  blt t0, t1, .main_skip94624346010112
  li   t2, 1
.main_skip94624346010112:
  sw   t2, -56(s0)
  #   br i1 %cmptmp, label %while.body, label %while.end
  lw   t0, -56(s0)
  beqz t0, .while.cond_br_false_path_94624346010280
  j .main_while.body
.while.cond_br_false_path_94624346010280:
  j .main_while.end
.main_while.body:
  #   %calltmp = call i32 @inc_a()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call inc_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -60(s0)
  #   %netmp = icmp ne i32 %calltmp, 0
  lw   t0, -60(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94624346012096
  li   t2, 1
.main_skip94624346012096:
  sw   t2, -64(s0)
  #   br i1 %netmp, label %and.rhs, label %and.end
  lw   t0, -64(s0)
  beqz t0, .while.body_br_false_path_94624346012408
  j .main_and.rhs
.while.body_br_false_path_94624346012408:
  lui  t2, 0
  sw   t2, -76(s0)
  j .main_and.end
.main_and.rhs:
  #   %calltmp1 = call i32 @inc_a()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call inc_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -68(s0)
  #   %netmp2 = icmp ne i32 %calltmp1, 0
  lw   t0, -68(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94624346012640
  li   t2, 1
.main_skip94624346012640:
  sw   t2, -72(s0)
  #   br label %and.end
  lw   t2, -72(s0)
  sw   t2, -76(s0)
  j .main_and.end
.main_and.end:
  #   %and.result = phi i1 [ false, %while.body ], [ %netmp2, %and.rhs ]
  #   br i1 %and.result, label %and.rhs3, label %and.end4
  lw   t0, -76(s0)
  beqz t0, .and.end_br_false_path_94624346013832
  j .main_and.rhs3
.and.end_br_false_path_94624346013832:
  lui  t2, 0
  sw   t2, -88(s0)
  j .main_and.end4
.main_and.rhs3:
  #   %calltmp5 = call i32 @inc_a()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call inc_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -80(s0)
  #   %netmp6 = icmp ne i32 %calltmp5, 0
  lw   t0, -80(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94624346014112
  li   t2, 1
.main_skip94624346014112:
  sw   t2, -84(s0)
  #   br label %and.end4
  lw   t2, -84(s0)
  sw   t2, -88(s0)
  j .main_and.end4
.main_and.end4:
  #   %and.result7 = phi i1 [ false, %and.end ], [ %netmp6, %and.rhs3 ]
  #   br i1 %and.result7, label %if.then, label %if.merge
  lw   t0, -88(s0)
  beqz t0, .and.end4_br_false_path_94624346014824
  j .main_if.then
.and.end4_br_false_path_94624346014824:
  j .main_if.merge
.main_if.then:
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -92(s0)
  #   %b.val = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -96(s0)
  #   %add_tmp = add i32 %a.val, %b.val
  lw   t0, -92(s0)
  lw   t1, -96(s0)
  add t2, t0, t1
  sw   t2, -100(s0)
  #   store i32 %add_tmp, i32* @a
  la   t1, a
  lw   t0, -100(s0)
  sw   t0, 0(t1)
  #   br label %if.merge
  j .main_if.merge
.main_if.merge:
  #   %calltmp8 = call i32 @inc_a()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call inc_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -104(s0)
  #   %cmptmp9 = icmp slt i32 %calltmp8, 14
  lw   t0, -104(s0)
  lui  t1, 0
  addi t1, t1, 14
  li   t2, 0
  bge t0, t1, .main_skip94624346015920
  li   t2, 1
.main_skip94624346015920:
  sw   t2, -108(s0)
  #   br i1 %cmptmp9, label %or.end, label %or.rhs
  lw   t0, -108(s0)
  beqz t0, .if.merge_br_false_path_94624346014968
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -120(s0)
  j .main_or.end
.if.merge_br_false_path_94624346014968:
  j .main_or.rhs
.main_or.rhs:
  #   %calltmp10 = call i32 @inc_a()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call inc_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -112(s0)
  #   %netmp11 = icmp ne i32 %calltmp10, 0
  lw   t0, -112(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94624346019312
  li   t2, 1
.main_skip94624346019312:
  sw   t2, -116(s0)
  #   br i1 %netmp11, label %and.rhs12, label %and.end13
  lw   t0, -116(s0)
  beqz t0, .or.rhs_br_false_path_94624346019736
  j .main_and.rhs12
.or.rhs_br_false_path_94624346019736:
  lui  t2, 0
  sw   t2, -144(s0)
  j .main_and.end13
.main_or.end:
  #   %or.result = phi i1 [ true, %if.merge ], [ %and.result18, %and.end13 ]
  #   br i1 %or.result, label %if.then19, label %if.else
  lw   t0, -120(s0)
  beqz t0, .or.end_br_false_path_94624346021672
  j .main_if.then19
.or.end_br_false_path_94624346021672:
  j .main_if.else
.main_and.rhs12:
  #   %calltmp14 = call i32 @inc_a()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call inc_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -124(s0)
  #   %calltmp15 = call i32 @inc_a()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call inc_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -128(s0)
  #   %sub_tmp = sub i32 %calltmp14, %calltmp15
  lw   t0, -124(s0)
  lw   t1, -128(s0)
  sub t2, t0, t1
  sw   t2, -132(s0)
  #   %add_tmp16 = add i32 %sub_tmp, 1
  lw   t0, -132(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -136(s0)
  #   %netmp17 = icmp ne i32 %add_tmp16, 0
  lw   t0, -136(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94624346020480
  li   t2, 1
.main_skip94624346020480:
  sw   t2, -140(s0)
  #   br label %and.end13
  lw   t2, -140(s0)
  sw   t2, -144(s0)
  j .main_and.end13
.main_and.end13:
  #   %and.result18 = phi i1 [ false, %or.rhs ], [ %netmp17, %and.rhs12 ]
  #   br label %or.end
  lw   t2, -144(s0)
  sw   t2, -120(s0)
  j .main_or.end
.main_if.then19:
  #   %b.val21 = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -148(s0)
  #   store i32 %b.val21, i32* @a
  la   t1, a
  lw   t0, -148(s0)
  sw   t0, 0(t1)
  #   %b.val22 = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -152(s0)
  #   %mul_tmp = mul i32 %b.val22, 2
  lw   t0, -152(s0)
  lui  t1, 0
  addi t1, t1, 2
  mul t2, t0, t1
  sw   t2, -156(s0)
  #   store i32 %mul_tmp, i32* @b
  la   t1, b
  lw   t0, -156(s0)
  sw   t0, 0(t1)
  #   br label %if.merge20
  j .main_if.merge20
.main_if.else:
  #   %calltmp23 = call i32 @inc_a()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call inc_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -160(s0)
  #   br label %if.merge20
  j .main_if.merge20
.main_if.merge20:
  #   %k.val24 = load i32, i32* %k
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -164(s0)
  #   %sub_tmp25 = sub i32 %k.val24, 1
  lw   t0, -164(s0)
  lui  t1, 0
  addi t1, t1, 1
  sub t2, t0, t1
  sw   t2, -168(s0)
  #   store i32 %sub_tmp25, i32* %k
  addi t1, s0, -48
  lw   t0, -168(s0)
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_while.end:
  #   %a.val26 = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -172(s0)
  #   %b.val27 = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -176(s0)
  #   %add_tmp28 = add i32 %a.val26, %b.val27
  lw   t0, -172(s0)
  lw   t1, -176(s0)
  add t2, t0, t1
  sw   t2, -180(s0)
  #   ret i32 %add_tmp28
  lw   a0, -180(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 188(sp)
  lw   s0, 184(sp)
  addi sp, sp, 192
  ret
