.data

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
  #   %result = alloca i32
  #   %d = alloca i32
  #   %c = alloca i32
  #   %b = alloca i32
  #   %a = alloca i32
  #   store i32 0, i32* %a
  addi t1, s0, -64
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %b
  addi t1, s0, -60
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %c
  addi t1, s0, -56
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %d
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %result
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 5, i32* %a
  addi t1, s0, -64
  lui  t0, 0
  addi t0, t0, 5
  sw   t0, 0(t1)
  #   store i32 5, i32* %b
  addi t1, s0, -60
  lui  t0, 0
  addi t0, t0, 5
  sw   t0, 0(t1)
  #   store i32 1, i32* %c
  addi t1, s0, -56
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   store i32 -2, i32* %d
  addi t1, s0, -52
  lui  t0, 0
  addi t0, t0, -2
  sw   t0, 0(t1)
  #   store i32 2, i32* %result
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   %d.val = load i32, i32* %d
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -68(s0)
  #   %mul_tmp = mul i32 %d.val, 1
  lw   t0, -68(s0)
  lui  t1, 0
  addi t1, t1, 1
  mul t2, t0, t1
  sw   t2, -72(s0)
  #   %div_tmp = sdiv i32 %mul_tmp, 2
  lw   t0, -72(s0)
  lui  t1, 0
  addi t1, t1, 2
  div t2, t0, t1
  sw   t2, -76(s0)
  #   %cmptmp = icmp slt i32 %div_tmp, 0
  lw   t0, -76(s0)
  lui  t1, 0
  li   t2, 0
  bge t0, t1, .main_skip93853139451840
  li   t2, 1
.main_skip93853139451840:
  sw   t2, -80(s0)
  #   br i1 %cmptmp, label %or.end, label %or.rhs
  lw   t0, -80(s0)
  beqz t0, .entry_br_false_path_93853139452232
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -100(s0)
  j .main_or.end
.entry_br_false_path_93853139452232:
  j .main_or.rhs
.main_or.rhs:
  #   %a.val = load i32, i32* %a
  addi t0, s0, -64
  lw   t1, 0(t0)
  sw   t1, -84(s0)
  #   %b.val = load i32, i32* %b
  addi t0, s0, -60
  lw   t1, 0(t0)
  sw   t1, -88(s0)
  #   %sub_tmp = sub i32 %a.val, %b.val
  lw   t0, -84(s0)
  lw   t1, -88(s0)
  sub t2, t0, t1
  sw   t2, -92(s0)
  #   %netmp = icmp ne i32 %sub_tmp, 0
  lw   t0, -92(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip93853139453168
  li   t2, 1
.main_skip93853139453168:
  sw   t2, -96(s0)
  #   br i1 %netmp, label %and.rhs, label %and.end
  lw   t0, -96(s0)
  beqz t0, .or.rhs_br_false_path_93853139453560
  j .main_and.rhs
.or.rhs_br_false_path_93853139453560:
  lui  t2, 0
  sw   t2, -120(s0)
  j .main_and.end
.main_or.end:
  #   %or.result = phi i1 [ true, %entry ], [ %and.result, %and.end ]
  #   br i1 %or.result, label %if.then, label %if.merge
  lw   t0, -100(s0)
  beqz t0, .or.end_br_false_path_93853139456008
  j .main_if.then
.or.end_br_false_path_93853139456008:
  j .main_if.merge
.main_and.rhs:
  #   %c.val = load i32, i32* %c
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -104(s0)
  #   %add_tmp = add i32 %c.val, 3
  lw   t0, -104(s0)
  lui  t1, 0
  addi t1, t1, 3
  add t2, t0, t1
  sw   t2, -108(s0)
  #   %mod_tmp = srem i32 %add_tmp, 2
  lw   t0, -108(s0)
  lui  t1, 0
  addi t1, t1, 2
  rem t2, t0, t1
  sw   t2, -112(s0)
  #   %netmp1 = icmp ne i32 %mod_tmp, 0
  lw   t0, -112(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip93853139454096
  li   t2, 1
.main_skip93853139454096:
  sw   t2, -116(s0)
  #   br label %and.end
  lw   t2, -116(s0)
  sw   t2, -120(s0)
  j .main_and.end
.main_and.end:
  #   %and.result = phi i1 [ false, %or.rhs ], [ %netmp1, %and.rhs ]
  #   br label %or.end
  lw   t2, -120(s0)
  sw   t2, -100(s0)
  j .main_or.end
.main_if.then:
  #   %result.val = load i32, i32* %result
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -124(s0)
  #   call void @print_int(i32 %result.val)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -124(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge
  j .main_if.merge
.main_if.merge:
  #   %d.val2 = load i32, i32* %d
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -128(s0)
  #   %mod_tmp3 = srem i32 %d.val2, 2
  lw   t0, -128(s0)
  lui  t1, 0
  addi t1, t1, 2
  rem t2, t0, t1
  sw   t2, -132(s0)
  #   %add_tmp4 = add i32 %mod_tmp3, 67
  lw   t0, -132(s0)
  lui  t1, 0
  addi t1, t1, 67
  add t2, t0, t1
  sw   t2, -136(s0)
  #   %cmptmp5 = icmp slt i32 %add_tmp4, 0
  lw   t0, -136(s0)
  lui  t1, 0
  li   t2, 0
  bge t0, t1, .main_skip93853139461808
  li   t2, 1
.main_skip93853139461808:
  sw   t2, -140(s0)
  #   br i1 %cmptmp5, label %or.end7, label %or.rhs6
  lw   t0, -140(s0)
  beqz t0, .if.merge_br_false_path_93853139456728
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -160(s0)
  j .main_or.end7
.if.merge_br_false_path_93853139456728:
  j .main_or.rhs6
.main_or.rhs6:
  #   %a.val8 = load i32, i32* %a
  addi t0, s0, -64
  lw   t1, 0(t0)
  sw   t1, -144(s0)
  #   %b.val9 = load i32, i32* %b
  addi t0, s0, -60
  lw   t1, 0(t0)
  sw   t1, -148(s0)
  #   %sub_tmp10 = sub i32 %a.val8, %b.val9
  lw   t0, -144(s0)
  lw   t1, -148(s0)
  sub t2, t0, t1
  sw   t2, -152(s0)
  #   %netmp11 = icmp ne i32 %sub_tmp10, 0
  lw   t0, -152(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip93853139462560
  li   t2, 1
.main_skip93853139462560:
  sw   t2, -156(s0)
  #   br i1 %netmp11, label %and.rhs12, label %and.end13
  lw   t0, -156(s0)
  beqz t0, .or.rhs6_br_false_path_93853139465048
  j .main_and.rhs12
.or.rhs6_br_false_path_93853139465048:
  lui  t2, 0
  sw   t2, -180(s0)
  j .main_and.end13
.main_or.end7:
  #   %or.result19 = phi i1 [ true, %if.merge ], [ %and.result18, %and.end13 ]
  #   br i1 %or.result19, label %if.then20, label %if.merge21
  lw   t0, -160(s0)
  beqz t0, .or.end7_br_false_path_93853139466648
  j .main_if.then20
.or.end7_br_false_path_93853139466648:
  j .main_if.merge21
.main_and.rhs12:
  #   %c.val14 = load i32, i32* %c
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -164(s0)
  #   %add_tmp15 = add i32 %c.val14, 2
  lw   t0, -164(s0)
  lui  t1, 0
  addi t1, t1, 2
  add t2, t0, t1
  sw   t2, -168(s0)
  #   %mod_tmp16 = srem i32 %add_tmp15, 2
  lw   t0, -168(s0)
  lui  t1, 0
  addi t1, t1, 2
  rem t2, t0, t1
  sw   t2, -172(s0)
  #   %netmp17 = icmp ne i32 %mod_tmp16, 0
  lw   t0, -172(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip93853139465616
  li   t2, 1
.main_skip93853139465616:
  sw   t2, -176(s0)
  #   br label %and.end13
  lw   t2, -176(s0)
  sw   t2, -180(s0)
  j .main_and.end13
.main_and.end13:
  #   %and.result18 = phi i1 [ false, %or.rhs6 ], [ %netmp17, %and.rhs12 ]
  #   br label %or.end7
  lw   t2, -180(s0)
  sw   t2, -160(s0)
  j .main_or.end7
.main_if.then20:
  #   store i32 4, i32* %result
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 4
  sw   t0, 0(t1)
  #   %result.val22 = load i32, i32* %result
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -184(s0)
  #   call void @print_int(i32 %result.val22)
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
  #   br label %if.merge21
  j .main_if.merge21
.main_if.merge21:
  #   ret i32 0
  lui  a0, 0
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 188(sp)
  lw   s0, 184(sp)
  addi sp, sp, 192
  ret
