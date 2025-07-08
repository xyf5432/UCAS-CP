.data
  .type a, @object
  .size a, 4
a:
  .word 0
  .type b, @object
  .size b, 4
b:
  .word 0
  .type d, @object
  .size d, 4
d:
  .word 0

.text
.globl main
.type main, @function

set_a:
  # Function Prologue for set_a
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
  sw   a0, -48(s0)
.set_a_entry:
  #   %val1 = alloca i32
  #   store i32 %val, i32* %val1
  addi t1, s0, -52
  lw   t0, -48(s0)
  sw   t0, 0(t1)
  #   %val.val = load i32, i32* %val1
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   store i32 %val.val, i32* @a
  la   t1, a
  lw   t0, -56(s0)
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   ret i32 %a.val
  lw   a0, -60(s0)
  j    .set_a_epilogue
.set_a_epilogue:
  # Function Epilogue for set_a
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret

set_b:
  # Function Prologue for set_b
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
  sw   a0, -48(s0)
.set_b_entry:
  #   %val1 = alloca i32
  #   store i32 %val, i32* %val1
  addi t1, s0, -52
  lw   t0, -48(s0)
  sw   t0, 0(t1)
  #   %val.val = load i32, i32* %val1
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   store i32 %val.val, i32* @b
  la   t1, b
  lw   t0, -56(s0)
  sw   t0, 0(t1)
  #   %b.val = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   ret i32 %b.val
  lw   a0, -60(s0)
  j    .set_b_epilogue
.set_b_epilogue:
  # Function Epilogue for set_b
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret

set_d:
  # Function Prologue for set_d
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
  sw   a0, -48(s0)
.set_d_entry:
  #   %val1 = alloca i32
  #   store i32 %val, i32* %val1
  addi t1, s0, -52
  lw   t0, -48(s0)
  sw   t0, 0(t1)
  #   %val.val = load i32, i32* %val1
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   store i32 %val.val, i32* @d
  la   t1, d
  lw   t0, -56(s0)
  sw   t0, 0(t1)
  #   %d.val = load i32, i32* @d
  la   t0, d
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   ret i32 %d.val
  lw   a0, -60(s0)
  j    .set_d_epilogue
.set_d_epilogue:
  # Function Epilogue for set_d
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret

main:
  # Function Prologue for main
  addi sp, sp, -352
  sw   ra, 348(sp)
  sw   s0, 344(sp)
  addi s0, sp, 352
.main_entry:
  #   store i32 2, i32* @a
  la   t1, a
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   store i32 3, i32* @b
  la   t1, b
  lui  t0, 0
  addi t0, t0, 3
  sw   t0, 0(t1)
  #   %calltmp = call i32 @set_a(i32 0)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  call set_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -48(s0)
  #   %netmp = icmp ne i32 %calltmp, 0
  lw   t0, -48(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94539046217392
  li   t2, 1
.main_skip94539046217392:
  sw   t2, -52(s0)
  #   br i1 %netmp, label %and.rhs, label %and.end
  lw   t0, -52(s0)
  beqz t0, .entry_br_false_path_94539046337000
  j .main_and.rhs
.entry_br_false_path_94539046337000:
  lui  t2, 0
  sw   t2, -64(s0)
  j .main_and.end
.main_and.rhs:
  #   %calltmp1 = call i32 @set_b(i32 1)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 1
  call set_b
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -56(s0)
  #   %netmp2 = icmp ne i32 %calltmp1, 0
  lw   t0, -56(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94539046218496
  li   t2, 1
.main_skip94539046218496:
  sw   t2, -60(s0)
  #   br label %and.end
  lw   t2, -60(s0)
  sw   t2, -64(s0)
  j .main_and.end
.main_and.end:
  #   %and.result = phi i1 [ false, %entry ], [ %netmp2, %and.rhs ]
  #   br i1 %and.result, label %if.then, label %if.merge
  lw   t0, -64(s0)
  beqz t0, .and.end_br_false_path_94539046337800
  j .main_if.then
.and.end_br_false_path_94539046337800:
  j .main_if.merge
.main_if.then:
  #   br label %if.merge
  j .main_if.merge
.main_if.merge:
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -68(s0)
  #   call void @print_int(i32 %a.val)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -68(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 32)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 32
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %b.val = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   call void @print_int(i32 %b.val)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -72(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 32)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 32
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   store i32 2, i32* @a
  la   t1, a
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   store i32 3, i32* @b
  la   t1, b
  lui  t0, 0
  addi t0, t0, 3
  sw   t0, 0(t1)
  #   %calltmp3 = call i32 @set_a(i32 0)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  call set_a
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -76(s0)
  #   %netmp4 = icmp ne i32 %calltmp3, 0
  lw   t0, -76(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94539046217280
  li   t2, 1
.main_skip94539046217280:
  sw   t2, -80(s0)
  #   br i1 %netmp4, label %and.rhs5, label %and.end6
  lw   t0, -80(s0)
  beqz t0, .if.merge_br_false_path_94539046337944
  j .main_and.rhs5
.if.merge_br_false_path_94539046337944:
  lui  t2, 0
  sw   t2, -92(s0)
  j .main_and.end6
.main_and.rhs5:
  #   %calltmp7 = call i32 @set_b(i32 1)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 1
  call set_b
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -84(s0)
  #   %netmp8 = icmp ne i32 %calltmp7, 0
  lw   t0, -84(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94539046157328
  li   t2, 1
.main_skip94539046157328:
  sw   t2, -88(s0)
  #   br label %and.end6
  lw   t2, -88(s0)
  sw   t2, -92(s0)
  j .main_and.end6
.main_and.end6:
  #   %and.result9 = phi i1 [ false, %if.merge ], [ %netmp8, %and.rhs5 ]
  #   br i1 %and.result9, label %if.then10, label %if.merge11
  lw   t0, -92(s0)
  beqz t0, .and.end6_br_false_path_94539046343064
  j .main_if.then10
.and.end6_br_false_path_94539046343064:
  j .main_if.merge11
.main_if.then10:
  #   br label %if.merge11
  j .main_if.merge11
.main_if.merge11:
  #   %a.val12 = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -96(s0)
  #   call void @print_int(i32 %a.val12)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -96(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 32)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 32
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %b.val13 = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -100(s0)
  #   call void @print_int(i32 %b.val13)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -100(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 10)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 10
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %c = alloca i32
  #   store i32 1, i32* %c
  addi t1, s0, -104
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   store i32 2, i32* @d
  la   t1, d
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   %c.val = load i32, i32* %c
  addi t0, s0, -104
  lw   t1, 0(t0)
  sw   t1, -108(s0)
  #   %cmptmp = icmp sge i32 %c.val, 1
  lw   t0, -108(s0)
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 0
  blt t0, t1, .main_skip94539046345952
  li   t2, 1
.main_skip94539046345952:
  sw   t2, -112(s0)
  #   br i1 %cmptmp, label %and.rhs14, label %and.end15
  lw   t0, -112(s0)
  beqz t0, .if.merge11_br_false_path_94539046346328
  j .main_and.rhs14
.if.merge11_br_false_path_94539046346328:
  lui  t2, 0
  sw   t2, -124(s0)
  j .main_and.end15
.main_and.rhs14:
  #   %calltmp16 = call i32 @set_d(i32 3)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 3
  call set_d
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -116(s0)
  #   %netmp17 = icmp ne i32 %calltmp16, 0
  lw   t0, -116(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94539046346688
  li   t2, 1
.main_skip94539046346688:
  sw   t2, -120(s0)
  #   br label %and.end15
  lw   t2, -120(s0)
  sw   t2, -124(s0)
  j .main_and.end15
.main_and.end15:
  #   %and.result18 = phi i1 [ false, %if.merge11 ], [ %netmp17, %and.rhs14 ]
  #   br i1 %and.result18, label %if.then19, label %if.merge20
  lw   t0, -124(s0)
  beqz t0, .and.end15_br_false_path_94539046347384
  j .main_if.then19
.and.end15_br_false_path_94539046347384:
  j .main_if.merge20
.main_if.then19:
  #   br label %if.merge20
  j .main_if.merge20
.main_if.merge20:
  #   %d.val = load i32, i32* @d
  la   t0, d
  lw   t1, 0(t0)
  sw   t1, -128(s0)
  #   call void @print_int(i32 %d.val)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -128(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 32)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 32
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %c.val21 = load i32, i32* %c
  addi t0, s0, -104
  lw   t1, 0(t0)
  sw   t1, -132(s0)
  #   %cmptmp22 = icmp sle i32 %c.val21, 1
  lw   t0, -132(s0)
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 0
  bgt t0, t1, .main_skip94539046348160
  li   t2, 1
.main_skip94539046348160:
  sw   t2, -136(s0)
  #   br i1 %cmptmp22, label %or.end, label %or.rhs
  lw   t0, -136(s0)
  beqz t0, .if.merge20_br_false_path_94539046348488
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -148(s0)
  j .main_or.end
.if.merge20_br_false_path_94539046348488:
  j .main_or.rhs
.main_or.rhs:
  #   %calltmp23 = call i32 @set_d(i32 4)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 4
  call set_d
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -140(s0)
  #   %netmp24 = icmp ne i32 %calltmp23, 0
  lw   t0, -140(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94539046348896
  li   t2, 1
.main_skip94539046348896:
  sw   t2, -144(s0)
  #   br label %or.end
  lw   t2, -144(s0)
  sw   t2, -148(s0)
  j .main_or.end
.main_or.end:
  #   %or.result = phi i1 [ true, %if.merge20 ], [ %netmp24, %or.rhs ]
  #   br i1 %or.result, label %if.then25, label %if.merge26
  lw   t0, -148(s0)
  beqz t0, .or.end_br_false_path_94539046349640
  j .main_if.then25
.or.end_br_false_path_94539046349640:
  j .main_if.merge26
.main_if.then25:
  #   br label %if.merge26
  j .main_if.merge26
.main_if.merge26:
  #   %d.val27 = load i32, i32* @d
  la   t0, d
  lw   t1, 0(t0)
  sw   t1, -152(s0)
  #   call void @print_int(i32 %d.val27)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -152(s0)
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 10)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 10
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br i1 true, label %if.then28, label %if.merge29
  lui  t0, 0
  addi t0, t0, -1
  beqz t0, .if.merge26_br_false_path_94539046349784
  j .main_if.then28
.if.merge26_br_false_path_94539046349784:
  j .main_if.merge29
.main_if.then28:
  #   call void @print_char(i8 65)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 65
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge29
  j .main_if.merge29
.main_if.merge29:
  #   br i1 false, label %if.then30, label %if.merge31
  lui  t0, 0
  beqz t0, .if.merge29_br_false_path_94539046350792
  j .main_if.then30
.if.merge29_br_false_path_94539046350792:
  j .main_if.merge31
.main_if.then30:
  #   call void @print_char(i8 66)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 66
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge31
  j .main_if.merge31
.main_if.merge31:
  #   br i1 false, label %if.then32, label %if.merge33
  lui  t0, 0
  beqz t0, .if.merge31_br_false_path_94539046353800
  j .main_if.then32
.if.merge31_br_false_path_94539046353800:
  j .main_if.merge33
.main_if.then32:
  #   call void @print_char(i8 67)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 67
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge33
  j .main_if.merge33
.main_if.merge33:
  #   br i1 true, label %if.then34, label %if.merge35
  lui  t0, 0
  addi t0, t0, -1
  beqz t0, .if.merge33_br_false_path_94539046353992
  j .main_if.then34
.if.merge33_br_false_path_94539046353992:
  j .main_if.merge35
.main_if.then34:
  #   call void @print_char(i8 68)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 68
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge35
  j .main_if.merge35
.main_if.merge35:
  #   br i1 true, label %if.then36, label %if.merge37
  lui  t0, 0
  addi t0, t0, -1
  beqz t0, .if.merge35_br_false_path_94539046354664
  j .main_if.then36
.if.merge35_br_false_path_94539046354664:
  j .main_if.merge37
.main_if.then36:
  #   call void @print_char(i8 69)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 69
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge37
  j .main_if.merge37
.main_if.merge37:
  #   call void @print_char(i8 10)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 10
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %i0 = alloca i32
  #   store i32 0, i32* %i0
  addi t1, s0, -156
  lui  t0, 0
  sw   t0, 0(t1)
  #   %i1 = alloca i32
  #   store i32 1, i32* %i1
  addi t1, s0, -160
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   %i2 = alloca i32
  #   store i32 2, i32* %i2
  addi t1, s0, -164
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   %i3 = alloca i32
  #   store i32 3, i32* %i3
  addi t1, s0, -168
  lui  t0, 0
  addi t0, t0, 3
  sw   t0, 0(t1)
  #   %i4 = alloca i32
  #   store i32 4, i32* %i4
  addi t1, s0, -172
  lui  t0, 0
  addi t0, t0, 4
  sw   t0, 0(t1)
  #   %i0.val = load i32, i32* %i0
  addi t0, s0, -156
  lw   t1, 0(t0)
  sw   t1, -176(s0)
  #   %i1.val = load i32, i32* %i1
  addi t0, s0, -160
  lw   t1, 0(t0)
  sw   t1, -180(s0)
  #   %cmptmp38 = icmp sge i32 %i0.val, %i1.val
  lw   t0, -176(s0)
  lw   t1, -180(s0)
  li   t2, 0
  blt t0, t1, .main_skip94539046358288
  li   t2, 1
.main_skip94539046358288:
  sw   t2, -184(s0)
  #   br i1 %cmptmp38, label %or.end40, label %or.rhs39
  lw   t0, -184(s0)
  beqz t0, .if.merge37_br_false_path_94539046358552
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -200(s0)
  j .main_or.end40
.if.merge37_br_false_path_94539046358552:
  j .main_or.rhs39
.main_or.rhs39:
  #   %i1.val41 = load i32, i32* %i1
  addi t0, s0, -160
  lw   t1, 0(t0)
  sw   t1, -188(s0)
  #   %i0.val42 = load i32, i32* %i0
  addi t0, s0, -156
  lw   t1, 0(t0)
  sw   t1, -192(s0)
  #   %cmptmp43 = icmp sle i32 %i1.val41, %i0.val42
  lw   t0, -188(s0)
  lw   t1, -192(s0)
  li   t2, 0
  bgt t0, t1, .main_skip94539046340656
  li   t2, 1
.main_skip94539046340656:
  sw   t2, -196(s0)
  #   br label %or.end40
  lw   t2, -196(s0)
  sw   t2, -200(s0)
  j .main_or.end40
.main_or.end40:
  #   %or.result44 = phi i1 [ true, %if.merge37 ], [ %cmptmp43, %or.rhs39 ]
  #   br i1 %or.result44, label %if.then45, label %if.merge46
  lw   t0, -200(s0)
  beqz t0, .or.end40_br_false_path_94539046341400
  j .main_if.then45
.or.end40_br_false_path_94539046341400:
  j .main_if.merge46
.main_if.then45:
  #   call void @print_char(i8 72)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 72
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge46
  j .main_if.merge46
.main_if.merge46:
  #   %i2.val = load i32, i32* %i2
  addi t0, s0, -164
  lw   t1, 0(t0)
  sw   t1, -204(s0)
  #   %i1.val47 = load i32, i32* %i1
  addi t0, s0, -160
  lw   t1, 0(t0)
  sw   t1, -208(s0)
  #   %cmptmp48 = icmp sge i32 %i2.val, %i1.val47
  lw   t0, -204(s0)
  lw   t1, -208(s0)
  li   t2, 0
  blt t0, t1, .main_skip94539046342096
  li   t2, 1
.main_skip94539046342096:
  sw   t2, -212(s0)
  #   br i1 %cmptmp48, label %and.rhs49, label %and.end50
  lw   t0, -212(s0)
  beqz t0, .if.merge46_br_false_path_94539046362904
  j .main_and.rhs49
.if.merge46_br_false_path_94539046362904:
  lui  t2, 0
  sw   t2, -228(s0)
  j .main_and.end50
.main_and.rhs49:
  #   %i4.val = load i32, i32* %i4
  addi t0, s0, -172
  lw   t1, 0(t0)
  sw   t1, -216(s0)
  #   %i3.val = load i32, i32* %i3
  addi t0, s0, -168
  lw   t1, 0(t0)
  sw   t1, -220(s0)
  #   %netmp51 = icmp ne i32 %i4.val, %i3.val
  lw   t0, -216(s0)
  lw   t1, -220(s0)
  li   t2, 0
  beq t0, t1, .main_skip94539046363248
  li   t2, 1
.main_skip94539046363248:
  sw   t2, -224(s0)
  #   br label %and.end50
  lw   t2, -224(s0)
  sw   t2, -228(s0)
  j .main_and.end50
.main_and.end50:
  #   %and.result52 = phi i1 [ false, %if.merge46 ], [ %netmp51, %and.rhs49 ]
  #   br i1 %and.result52, label %if.then53, label %if.merge54
  lw   t0, -228(s0)
  beqz t0, .and.end50_br_false_path_94539046363976
  j .main_if.then53
.and.end50_br_false_path_94539046363976:
  j .main_if.merge54
.main_if.then53:
  #   call void @print_char(i8 73)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 73
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge54
  j .main_if.merge54
.main_if.merge54:
  #   %i0.val55 = load i32, i32* %i0
  addi t0, s0, -156
  lw   t1, 0(t0)
  sw   t1, -232(s0)
  #   %i1.val56 = load i32, i32* %i1
  addi t0, s0, -160
  lw   t1, 0(t0)
  sw   t1, -236(s0)
  #   %tobool = icmp ne i32 %i1.val56, 0
  lw   t0, -236(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94539046364864
  li   t2, 1
.main_skip94539046364864:
  sw   t2, -240(s0)
  #   %logicalnot = icmp eq i1 %tobool, false
  lw   t0, -240(s0)
  lui  t1, 0
  li   t2, 0
  bne t0, t1, .main_skip94539046364976
  li   t2, 1
.main_skip94539046364976:
  sw   t2, -244(s0)
  #   %booltoint = zext i1 %logicalnot to i32
  lw   t0, -244(s0)
  sw   t0, -248(s0)
  #   %eqtmp = icmp eq i32 %i0.val55, %booltoint
  lw   t0, -232(s0)
  lw   t1, -248(s0)
  li   t2, 0
  bne t0, t1, .main_skip94539046365184
  li   t2, 1
.main_skip94539046365184:
  sw   t2, -252(s0)
  #   br i1 %eqtmp, label %and.rhs57, label %and.end58
  lw   t0, -252(s0)
  beqz t0, .if.merge54_br_false_path_94539046364168
  j .main_and.rhs57
.if.merge54_br_false_path_94539046364168:
  lui  t2, 0
  sw   t2, -268(s0)
  j .main_and.end58
.main_and.rhs57:
  #   %i3.val59 = load i32, i32* %i3
  addi t0, s0, -168
  lw   t1, 0(t0)
  sw   t1, -256(s0)
  #   %i3.val60 = load i32, i32* %i3
  addi t0, s0, -168
  lw   t1, 0(t0)
  sw   t1, -260(s0)
  #   %cmptmp61 = icmp slt i32 %i3.val59, %i3.val60
  lw   t0, -256(s0)
  lw   t1, -260(s0)
  li   t2, 0
  bge t0, t1, .main_skip94539046365936
  li   t2, 1
.main_skip94539046365936:
  sw   t2, -264(s0)
  #   br label %and.end58
  lw   t2, -264(s0)
  sw   t2, -268(s0)
  j .main_and.end58
.main_and.end58:
  #   %and.result62 = phi i1 [ false, %if.merge54 ], [ %cmptmp61, %and.rhs57 ]
  #   br i1 %and.result62, label %or.end64, label %or.rhs63
  lw   t0, -268(s0)
  beqz t0, .and.end58_br_false_path_94539046366680
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -284(s0)
  j .main_or.end64
.and.end58_br_false_path_94539046366680:
  j .main_or.rhs63
.main_or.rhs63:
  #   %i4.val65 = load i32, i32* %i4
  addi t0, s0, -172
  lw   t1, 0(t0)
  sw   t1, -272(s0)
  #   %i4.val66 = load i32, i32* %i4
  addi t0, s0, -172
  lw   t1, 0(t0)
  sw   t1, -276(s0)
  #   %cmptmp67 = icmp sge i32 %i4.val65, %i4.val66
  lw   t0, -272(s0)
  lw   t1, -276(s0)
  li   t2, 0
  blt t0, t1, .main_skip94539046352176
  li   t2, 1
.main_skip94539046352176:
  sw   t2, -280(s0)
  #   br label %or.end64
  lw   t2, -280(s0)
  sw   t2, -284(s0)
  j .main_or.end64
.main_or.end64:
  #   %or.result68 = phi i1 [ true, %and.end58 ], [ %cmptmp67, %or.rhs63 ]
  #   br i1 %or.result68, label %if.then69, label %if.merge70
  lw   t0, -284(s0)
  beqz t0, .or.end64_br_false_path_94539046352920
  j .main_if.then69
.or.end64_br_false_path_94539046352920:
  j .main_if.merge70
.main_if.then69:
  #   call void @print_char(i8 74)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 74
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge70
  j .main_if.merge70
.main_if.merge70:
  #   %i0.val71 = load i32, i32* %i0
  addi t0, s0, -156
  lw   t1, 0(t0)
  sw   t1, -288(s0)
  #   %i1.val72 = load i32, i32* %i1
  addi t0, s0, -160
  lw   t1, 0(t0)
  sw   t1, -292(s0)
  #   %tobool73 = icmp ne i32 %i1.val72, 0
  lw   t0, -292(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94539046370288
  li   t2, 1
.main_skip94539046370288:
  sw   t2, -296(s0)
  #   %logicalnot74 = icmp eq i1 %tobool73, false
  lw   t0, -296(s0)
  lui  t1, 0
  li   t2, 0
  bne t0, t1, .main_skip94539046370448
  li   t2, 1
.main_skip94539046370448:
  sw   t2, -300(s0)
  #   %booltoint75 = zext i1 %logicalnot74 to i32
  lw   t0, -300(s0)
  sw   t0, -304(s0)
  #   %eqtmp76 = icmp eq i32 %i0.val71, %booltoint75
  lw   t0, -288(s0)
  lw   t1, -304(s0)
  li   t2, 0
  bne t0, t1, .main_skip94539046370656
  li   t2, 1
.main_skip94539046370656:
  sw   t2, -308(s0)
  #   br i1 %eqtmp76, label %or.end78, label %or.rhs77
  lw   t0, -308(s0)
  beqz t0, .if.merge70_br_false_path_94539046353112
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -324(s0)
  j .main_or.end78
.if.merge70_br_false_path_94539046353112:
  j .main_or.rhs77
.main_or.rhs77:
  #   %i3.val79 = load i32, i32* %i3
  addi t0, s0, -168
  lw   t1, 0(t0)
  sw   t1, -312(s0)
  #   %i3.val80 = load i32, i32* %i3
  addi t0, s0, -168
  lw   t1, 0(t0)
  sw   t1, -316(s0)
  #   %cmptmp81 = icmp slt i32 %i3.val79, %i3.val80
  lw   t0, -312(s0)
  lw   t1, -316(s0)
  li   t2, 0
  bge t0, t1, .main_skip94539046371408
  li   t2, 1
.main_skip94539046371408:
  sw   t2, -320(s0)
  #   br i1 %cmptmp81, label %and.rhs82, label %and.end83
  lw   t0, -320(s0)
  beqz t0, .or.rhs77_br_false_path_94539046371848
  j .main_and.rhs82
.or.rhs77_br_false_path_94539046371848:
  lui  t2, 0
  sw   t2, -340(s0)
  j .main_and.end83
.main_or.end78:
  #   %or.result88 = phi i1 [ true, %if.merge70 ], [ %and.result87, %and.end83 ]
  #   br i1 %or.result88, label %if.then89, label %if.merge90
  lw   t0, -324(s0)
  beqz t0, .or.end78_br_false_path_94539046373304
  j .main_if.then89
.or.end78_br_false_path_94539046373304:
  j .main_if.merge90
.main_and.rhs82:
  #   %i4.val84 = load i32, i32* %i4
  addi t0, s0, -172
  lw   t1, 0(t0)
  sw   t1, -328(s0)
  #   %i4.val85 = load i32, i32* %i4
  addi t0, s0, -172
  lw   t1, 0(t0)
  sw   t1, -332(s0)
  #   %cmptmp86 = icmp sge i32 %i4.val84, %i4.val85
  lw   t0, -328(s0)
  lw   t1, -332(s0)
  li   t2, 0
  blt t0, t1, .main_skip94539046372256
  li   t2, 1
.main_skip94539046372256:
  sw   t2, -336(s0)
  #   br label %and.end83
  lw   t2, -336(s0)
  sw   t2, -340(s0)
  j .main_and.end83
.main_and.end83:
  #   %and.result87 = phi i1 [ false, %or.rhs77 ], [ %cmptmp86, %and.rhs82 ]
  #   br label %or.end78
  lw   t2, -340(s0)
  sw   t2, -324(s0)
  j .main_or.end78
.main_if.then89:
  #   call void @print_char(i8 75)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 75
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge90
  j .main_if.merge90
.main_if.merge90:
  #   call void @print_char(i8 10)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 10
  call print_char
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
  lw   ra, 348(sp)
  lw   s0, 344(sp)
  addi sp, sp, 352
  ret
