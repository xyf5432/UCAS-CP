.data
  .type k, @object
  .size k, 4
k:
  .word 0

.text
.globl main
.type main, @function

main:
  # Function Prologue for main
  addi sp, sp, -144
  sw   ra, 140(sp)
  sw   s0, 136(sp)
  addi s0, sp, 144
.main_entry:
  #   store i32 3389, i32* @k
  la   t1, k
  lui  t0, 1
  addi t0, t0, -707
  sw   t0, 0(t1)
  #   %k.val = load i32, i32* @k
  la   t0, k
  lw   t1, 0(t0)
  sw   t1, -48(s0)
  #   %cmptmp = icmp slt i32 %k.val, 10000
  lw   t0, -48(s0)
  lui  t1, 2
  addi t1, t1, 1808
  li   t2, 0
  bge t0, t1, .main_skip94374397198896
  li   t2, 1
.main_skip94374397198896:
  sw   t2, -52(s0)
  #   br i1 %cmptmp, label %if.then, label %if.merge
  lw   t0, -52(s0)
  beqz t0, .entry_br_false_path_94374397228408
  j .main_if.then
.entry_br_false_path_94374397228408:
  j .main_if.merge
.main_if.then:
  #   %k.val1 = load i32, i32* @k
  la   t0, k
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %add_tmp = add i32 %k.val1, 1
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -60(s0)
  #   store i32 %add_tmp, i32* @k
  la   t1, k
  lw   t0, -60(s0)
  sw   t0, 0(t1)
  #   %k = alloca i32
  #   store i32 112, i32* %k
  addi t1, s0, -64
  lui  t0, 0
  addi t0, t0, 112
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_if.merge:
  #   %k.val17 = load i32, i32* @k
  la   t0, k
  lw   t1, 0(t0)
  sw   t1, -68(s0)
  #   ret i32 %k.val17
  lw   a0, -68(s0)
  j    .main_epilogue
.main_while.cond:
  #   %k.val2 = load i32, i32* %k
  addi t0, s0, -64
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   %cmptmp3 = icmp sgt i32 %k.val2, 10
  lw   t0, -72(s0)
  lui  t1, 0
  addi t1, t1, 10
  li   t2, 0
  ble t0, t1, .main_skip94374397231616
  li   t2, 1
.main_skip94374397231616:
  sw   t2, -76(s0)
  #   br i1 %cmptmp3, label %while.body, label %while.end
  lw   t0, -76(s0)
  beqz t0, .while.cond_br_false_path_94374397231784
  j .main_while.body
.while.cond_br_false_path_94374397231784:
  j .main_while.end
.main_while.body:
  #   %k.val4 = load i32, i32* %k
  addi t0, s0, -64
  lw   t1, 0(t0)
  sw   t1, -80(s0)
  #   %sub_tmp = sub i32 %k.val4, 88
  lw   t0, -80(s0)
  lui  t1, 0
  addi t1, t1, 88
  sub t2, t0, t1
  sw   t2, -84(s0)
  #   store i32 %sub_tmp, i32* %k
  addi t1, s0, -64
  lw   t0, -84(s0)
  sw   t0, 0(t1)
  #   %k.val5 = load i32, i32* %k
  addi t0, s0, -64
  lw   t1, 0(t0)
  sw   t1, -88(s0)
  #   %cmptmp6 = icmp slt i32 %k.val5, 1000
  lw   t0, -88(s0)
  lui  t1, 0
  addi t1, t1, 1000
  li   t2, 0
  bge t0, t1, .main_skip94374397233168
  li   t2, 1
.main_skip94374397233168:
  sw   t2, -92(s0)
  #   br i1 %cmptmp6, label %if.then7, label %if.merge8
  lw   t0, -92(s0)
  beqz t0, .while.body_br_false_path_94374397233592
  j .main_if.then7
.while.body_br_false_path_94374397233592:
  j .main_if.merge8
.main_if.then7:
  #   %g = alloca i32
  #   store i32 9, i32* %g
  addi t1, s0, -96
  lui  t0, 0
  addi t0, t0, 9
  sw   t0, 0(t1)
  #   %l = alloca i32
  #   store i32 11, i32* %l
  addi t1, s0, -100
  lui  t0, 0
  addi t0, t0, 11
  sw   t0, 0(t1)
  #   store i32 10, i32* %g
  addi t1, s0, -96
  lui  t0, 0
  addi t0, t0, 10
  sw   t0, 0(t1)
  #   %k.val9 = load i32, i32* %k
  addi t0, s0, -64
  lw   t1, 0(t0)
  sw   t1, -104(s0)
  #   %g.val = load i32, i32* %g
  addi t0, s0, -96
  lw   t1, 0(t0)
  sw   t1, -108(s0)
  #   %sub_tmp10 = sub i32 %k.val9, %g.val
  lw   t0, -104(s0)
  lw   t1, -108(s0)
  sub t2, t0, t1
  sw   t2, -112(s0)
  #   store i32 %sub_tmp10, i32* %k
  addi t1, s0, -64
  lw   t0, -112(s0)
  sw   t0, 0(t1)
  #   %g11 = alloca i32
  #   store i32 11, i32* %g11
  addi t1, s0, -116
  lui  t0, 0
  addi t0, t0, 11
  sw   t0, 0(t1)
  #   %k.val12 = load i32, i32* %k
  addi t0, s0, -64
  lw   t1, 0(t0)
  sw   t1, -120(s0)
  #   %g.val13 = load i32, i32* %g11
  addi t0, s0, -116
  lw   t1, 0(t0)
  sw   t1, -124(s0)
  #   %add_tmp14 = add i32 %k.val12, %g.val13
  lw   t0, -120(s0)
  lw   t1, -124(s0)
  add t2, t0, t1
  sw   t2, -128(s0)
  #   %l.val = load i32, i32* %l
  addi t0, s0, -100
  lw   t1, 0(t0)
  sw   t1, -132(s0)
  #   %add_tmp15 = add i32 %add_tmp14, %l.val
  lw   t0, -128(s0)
  lw   t1, -132(s0)
  add t2, t0, t1
  sw   t2, -136(s0)
  #   store i32 %add_tmp15, i32* %k
  addi t1, s0, -64
  lw   t0, -136(s0)
  sw   t0, 0(t1)
  #   br label %if.merge8
  j .main_if.merge8
.main_if.merge8:
  #   br label %while.cond
  j .main_while.cond
.main_while.end:
  #   %k.val16 = load i32, i32* %k
  addi t0, s0, -64
  lw   t1, 0(t0)
  sw   t1, -140(s0)
  #   call void @print_int(i32 %k.val16)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -140(s0)
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
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 140(sp)
  lw   s0, 136(sp)
  addi sp, sp, 144
  ret
