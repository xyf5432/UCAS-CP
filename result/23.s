.data
  .type a, @object
  .size a, 4
a:
  .word 1
  .type b, @object
  .size b, 4
b:
  .word 0
  .type c, @object
  .size c, 4
c:
  .word 1
  .type d, @object
  .size d, 4
d:
  .word 2
  .type e, @object
  .size e, 4
e:
  .word 4

.text
.globl main
.type main, @function

main:
  # Function Prologue for main
  addi sp, sp, -192
  sw   ra, 188(sp)
  sw   s0, 184(sp)
  addi s0, sp, 192
.main_entry:
  #   %flag = alloca i32
  #   store i32 0, i32* %flag
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -52(s0)
  #   %b.val = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %mul_tmp = mul i32 %a.val, %b.val
  lw   t0, -52(s0)
  lw   t1, -56(s0)
  mul t2, t0, t1
  sw   t2, -60(s0)
  #   %c.val = load i32, i32* @c
  la   t0, c
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %div_tmp = sdiv i32 %mul_tmp, %c.val
  lw   t0, -60(s0)
  lw   t1, -64(s0)
  div t2, t0, t1
  sw   t2, -68(s0)
  #   %e.val = load i32, i32* @e
  la   t0, e
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   %d.val = load i32, i32* @d
  la   t0, d
  lw   t1, 0(t0)
  sw   t1, -76(s0)
  #   %add_tmp = add i32 %e.val, %d.val
  lw   t0, -72(s0)
  lw   t1, -76(s0)
  add t2, t0, t1
  sw   t2, -80(s0)
  #   %eqtmp = icmp eq i32 %div_tmp, %add_tmp
  lw   t0, -68(s0)
  lw   t1, -80(s0)
  li   t2, 0
  bne t0, t1, .main_skip94827270935792
  li   t2, 1
.main_skip94827270935792:
  sw   t2, -84(s0)
  #   br i1 %eqtmp, label %and.rhs, label %and.end
  lw   t0, -84(s0)
  beqz t0, .entry_br_false_path_94827270936600
  j .main_and.rhs
.entry_br_false_path_94827270936600:
  lui  t2, 0
  sw   t2, -132(s0)
  j .main_and.end
.main_and.rhs:
  #   %a.val1 = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -88(s0)
  #   %a.val2 = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -92(s0)
  #   %b.val3 = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -96(s0)
  #   %add_tmp4 = add i32 %a.val2, %b.val3
  lw   t0, -92(s0)
  lw   t1, -96(s0)
  add t2, t0, t1
  sw   t2, -100(s0)
  #   %mul_tmp5 = mul i32 %a.val1, %add_tmp4
  lw   t0, -88(s0)
  lw   t1, -100(s0)
  mul t2, t0, t1
  sw   t2, -104(s0)
  #   %c.val6 = load i32, i32* @c
  la   t0, c
  lw   t1, 0(t0)
  sw   t1, -108(s0)
  #   %add_tmp7 = add i32 %mul_tmp5, %c.val6
  lw   t0, -104(s0)
  lw   t1, -108(s0)
  add t2, t0, t1
  sw   t2, -112(s0)
  #   %d.val8 = load i32, i32* @d
  la   t0, d
  lw   t1, 0(t0)
  sw   t1, -116(s0)
  #   %e.val9 = load i32, i32* @e
  la   t0, e
  lw   t1, 0(t0)
  sw   t1, -120(s0)
  #   %add_tmp10 = add i32 %d.val8, %e.val9
  lw   t0, -116(s0)
  lw   t1, -120(s0)
  add t2, t0, t1
  sw   t2, -124(s0)
  #   %cmptmp = icmp sle i32 %add_tmp7, %add_tmp10
  lw   t0, -112(s0)
  lw   t1, -124(s0)
  li   t2, 0
  bgt t0, t1, .main_skip94827270938080
  li   t2, 1
.main_skip94827270938080:
  sw   t2, -128(s0)
  #   br label %and.end
  lw   t2, -128(s0)
  sw   t2, -132(s0)
  j .main_and.end
.main_and.end:
  #   %and.result = phi i1 [ false, %entry ], [ %cmptmp, %and.rhs ]
  #   br i1 %and.result, label %or.end, label %or.rhs
  lw   t0, -132(s0)
  beqz t0, .and.end_br_false_path_94827270939624
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -180(s0)
  j .main_or.end
.and.end_br_false_path_94827270939624:
  j .main_or.rhs
.main_or.rhs:
  #   %a.val11 = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -136(s0)
  #   %b.val12 = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -140(s0)
  #   %c.val13 = load i32, i32* @c
  la   t0, c
  lw   t1, 0(t0)
  sw   t1, -144(s0)
  #   %mul_tmp14 = mul i32 %b.val12, %c.val13
  lw   t0, -140(s0)
  lw   t1, -144(s0)
  mul t2, t0, t1
  sw   t2, -148(s0)
  #   %sub_tmp = sub i32 %a.val11, %mul_tmp14
  lw   t0, -136(s0)
  lw   t1, -148(s0)
  sub t2, t0, t1
  sw   t2, -152(s0)
  #   %d.val15 = load i32, i32* @d
  la   t0, d
  lw   t1, 0(t0)
  sw   t1, -156(s0)
  #   %a.val16 = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -160(s0)
  #   %c.val17 = load i32, i32* @c
  la   t0, c
  lw   t1, 0(t0)
  sw   t1, -164(s0)
  #   %div_tmp18 = sdiv i32 %a.val16, %c.val17
  lw   t0, -160(s0)
  lw   t1, -164(s0)
  div t2, t0, t1
  sw   t2, -168(s0)
  #   %sub_tmp19 = sub i32 %d.val15, %div_tmp18
  lw   t0, -156(s0)
  lw   t1, -168(s0)
  sub t2, t0, t1
  sw   t2, -172(s0)
  #   %eqtmp20 = icmp eq i32 %sub_tmp, %sub_tmp19
  lw   t0, -152(s0)
  lw   t1, -172(s0)
  li   t2, 0
  bne t0, t1, .main_skip94827270943200
  li   t2, 1
.main_skip94827270943200:
  sw   t2, -176(s0)
  #   br label %or.end
  lw   t2, -176(s0)
  sw   t2, -180(s0)
  j .main_or.end
.main_or.end:
  #   %or.result = phi i1 [ true, %and.end ], [ %eqtmp20, %or.rhs ]
  #   br i1 %or.result, label %if.then, label %if.merge
  lw   t0, -180(s0)
  beqz t0, .or.end_br_false_path_94827270943960
  j .main_if.then
.or.end_br_false_path_94827270943960:
  j .main_if.merge
.main_if.then:
  #   store i32 1, i32* %flag
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   br label %if.merge
  j .main_if.merge
.main_if.merge:
  #   %flag.val = load i32, i32* %flag
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -184(s0)
  #   call void @print_int(i32 %flag.val)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -184(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %flag.val21 = load i32, i32* %flag
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -188(s0)
  #   ret i32 %flag.val21
  lw   a0, -188(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 188(sp)
  lw   s0, 184(sp)
  addi sp, sp, 192
  ret
