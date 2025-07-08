.data
  .type g, @object
  .size g, 4
g:
  .word 0

.text
.globl main
.type main, @function

func:
  # Function Prologue for func
  addi sp, sp, -80
  sw   ra, 76(sp)
  sw   s0, 72(sp)
  addi s0, sp, 80
  sw   a0, -48(s0)
.func_entry:
  #   %n1 = alloca i32
  #   store i32 %n, i32* %n1
  addi t1, s0, -52
  lw   t0, -48(s0)
  sw   t0, 0(t1)
  #   %g.val = load i32, i32* @g
  la   t0, g
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %n.val = load i32, i32* %n1
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   %add_tmp = add i32 %g.val, %n.val
  lw   t0, -56(s0)
  lw   t1, -60(s0)
  add t2, t0, t1
  sw   t2, -64(s0)
  #   store i32 %add_tmp, i32* @g
  la   t1, g
  lw   t0, -64(s0)
  sw   t0, 0(t1)
  #   %g.val2 = load i32, i32* @g
  la   t0, g
  lw   t1, 0(t0)
  sw   t1, -68(s0)
  #   call void @print_int(i32 %g.val2)
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
  #   %g.val3 = load i32, i32* @g
  la   t0, g
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   ret i32 %g.val3
  lw   a0, -72(s0)
  j    .func_epilogue
.func_epilogue:
  # Function Epilogue for func
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
  #   %i = alloca i32
  #   store i32 0, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   %calltmp = call i32 @get_int()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call get_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -52(s0)
  #   store i32 %calltmp, i32* %i
  addi t1, s0, -48
  lw   t0, -52(s0)
  sw   t0, 0(t1)
  #   %i.val = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %cmptmp = icmp sgt i32 %i.val, 10
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 10
  li   t2, 0
  ble t0, t1, .main_skip94226551588528
  li   t2, 1
.main_skip94226551588528:
  sw   t2, -60(s0)
  #   br i1 %cmptmp, label %and.rhs, label %and.end
  lw   t0, -60(s0)
  beqz t0, .entry_br_false_path_94226551588920
  j .main_and.rhs
.entry_br_false_path_94226551588920:
  lui  t2, 0
  sw   t2, -76(s0)
  j .main_and.end
.main_and.rhs:
  #   %i.val1 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %calltmp2 = call i32 @func(i32 %i.val1)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -64(s0)
  call func
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -68(s0)
  #   %tobool = icmp ne i32 %calltmp2, 0
  lw   t0, -68(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94226551589360
  li   t2, 1
.main_skip94226551589360:
  sw   t2, -72(s0)
  #   br label %and.end
  lw   t2, -72(s0)
  sw   t2, -76(s0)
  j .main_and.end
.main_and.end:
  #   %and.result = phi i1 [ false, %entry ], [ %tobool, %and.rhs ]
  #   br i1 %and.result, label %if.then, label %if.else
  lw   t0, -76(s0)
  beqz t0, .and.end_br_false_path_94226551590584
  j .main_if.then
.and.end_br_false_path_94226551590584:
  j .main_if.else
.main_if.then:
  #   store i32 1, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   br label %if.merge
  j .main_if.merge
.main_if.else:
  #   store i32 0, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %if.merge
  j .main_if.merge
.main_if.merge:
  #   %calltmp3 = call i32 @get_int()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call get_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -80(s0)
  #   store i32 %calltmp3, i32* %i
  addi t1, s0, -48
  lw   t0, -80(s0)
  sw   t0, 0(t1)
  #   %i.val4 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -84(s0)
  #   %cmptmp5 = icmp sgt i32 %i.val4, 11
  lw   t0, -84(s0)
  lui  t1, 0
  addi t1, t1, 11
  li   t2, 0
  ble t0, t1, .main_skip94226551591616
  li   t2, 1
.main_skip94226551591616:
  sw   t2, -88(s0)
  #   br i1 %cmptmp5, label %and.rhs6, label %and.end7
  lw   t0, -88(s0)
  beqz t0, .if.merge_br_false_path_94226551592040
  j .main_and.rhs6
.if.merge_br_false_path_94226551592040:
  lui  t2, 0
  sw   t2, -104(s0)
  j .main_and.end7
.main_and.rhs6:
  #   %i.val8 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -92(s0)
  #   %calltmp9 = call i32 @func(i32 %i.val8)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -92(s0)
  call func
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -96(s0)
  #   %tobool10 = icmp ne i32 %calltmp9, 0
  lw   t0, -96(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94226551592528
  li   t2, 1
.main_skip94226551592528:
  sw   t2, -100(s0)
  #   br label %and.end7
  lw   t2, -100(s0)
  sw   t2, -104(s0)
  j .main_and.end7
.main_and.end7:
  #   %and.result11 = phi i1 [ false, %if.merge ], [ %tobool10, %and.rhs6 ]
  #   br i1 %and.result11, label %if.then12, label %if.else13
  lw   t0, -104(s0)
  beqz t0, .and.end7_br_false_path_94226551594200
  j .main_if.then12
.and.end7_br_false_path_94226551594200:
  j .main_if.else13
.main_if.then12:
  #   store i32 1, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   br label %if.merge14
  j .main_if.merge14
.main_if.else13:
  #   store i32 0, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %if.merge14
  j .main_if.merge14
.main_if.merge14:
  #   %calltmp15 = call i32 @get_int()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call get_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -108(s0)
  #   store i32 %calltmp15, i32* %i
  addi t1, s0, -48
  lw   t0, -108(s0)
  sw   t0, 0(t1)
  #   %i.val16 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -112(s0)
  #   %cmptmp17 = icmp sle i32 %i.val16, 99
  lw   t0, -112(s0)
  lui  t1, 0
  addi t1, t1, 99
  li   t2, 0
  bgt t0, t1, .main_skip94226551597264
  li   t2, 1
.main_skip94226551597264:
  sw   t2, -116(s0)
  #   br i1 %cmptmp17, label %or.end, label %or.rhs
  lw   t0, -116(s0)
  beqz t0, .if.merge14_br_false_path_94226551597640
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -132(s0)
  j .main_or.end
.if.merge14_br_false_path_94226551597640:
  j .main_or.rhs
.main_or.rhs:
  #   %i.val18 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -120(s0)
  #   %calltmp19 = call i32 @func(i32 %i.val18)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -120(s0)
  call func
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -124(s0)
  #   %tobool20 = icmp ne i32 %calltmp19, 0
  lw   t0, -124(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94226551598128
  li   t2, 1
.main_skip94226551598128:
  sw   t2, -128(s0)
  #   br label %or.end
  lw   t2, -128(s0)
  sw   t2, -132(s0)
  j .main_or.end
.main_or.end:
  #   %or.result = phi i1 [ true, %if.merge14 ], [ %tobool20, %or.rhs ]
  #   br i1 %or.result, label %if.then21, label %if.else22
  lw   t0, -132(s0)
  beqz t0, .or.end_br_false_path_94226551599048
  j .main_if.then21
.or.end_br_false_path_94226551599048:
  j .main_if.else22
.main_if.then21:
  #   store i32 1, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   br label %if.merge23
  j .main_if.merge23
.main_if.else22:
  #   store i32 0, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %if.merge23
  j .main_if.merge23
.main_if.merge23:
  #   %calltmp24 = call i32 @get_int()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call get_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -136(s0)
  #   store i32 %calltmp24, i32* %i
  addi t1, s0, -48
  lw   t0, -136(s0)
  sw   t0, 0(t1)
  #   %i.val25 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -140(s0)
  #   %cmptmp26 = icmp sle i32 %i.val25, 100
  lw   t0, -140(s0)
  lui  t1, 0
  addi t1, t1, 100
  li   t2, 0
  bgt t0, t1, .main_skip94226551600048
  li   t2, 1
.main_skip94226551600048:
  sw   t2, -144(s0)
  #   br i1 %cmptmp26, label %or.end28, label %or.rhs27
  lw   t0, -144(s0)
  beqz t0, .if.merge23_br_false_path_94226551600488
  lui  t2, 0
  addi t2, t2, -1
  sw   t2, -160(s0)
  j .main_or.end28
.if.merge23_br_false_path_94226551600488:
  j .main_or.rhs27
.main_or.rhs27:
  #   %i.val29 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -148(s0)
  #   %calltmp30 = call i32 @func(i32 %i.val29)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -148(s0)
  call func
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -152(s0)
  #   %tobool31 = icmp ne i32 %calltmp30, 0
  lw   t0, -152(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94226551600944
  li   t2, 1
.main_skip94226551600944:
  sw   t2, -156(s0)
  #   br label %or.end28
  lw   t2, -156(s0)
  sw   t2, -160(s0)
  j .main_or.end28
.main_or.end28:
  #   %or.result32 = phi i1 [ true, %if.merge23 ], [ %tobool31, %or.rhs27 ]
  #   br i1 %or.result32, label %if.then33, label %if.else34
  lw   t0, -160(s0)
  beqz t0, .or.end28_br_false_path_94226551603384
  j .main_if.then33
.or.end28_br_false_path_94226551603384:
  j .main_if.else34
.main_if.then33:
  #   store i32 1, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   br label %if.merge35
  j .main_if.merge35
.main_if.else34:
  #   store i32 0, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %if.merge35
  j .main_if.merge35
.main_if.merge35:
  #   %calltmp36 = call i32 @func(i32 99)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 99
  call func
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -164(s0)
  #   %tobool37 = icmp ne i32 %calltmp36, 0
  lw   t0, -164(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94226551604128
  li   t2, 1
.main_skip94226551604128:
  sw   t2, -168(s0)
  #   %logicalnot = icmp eq i1 %tobool37, false
  lw   t0, -168(s0)
  lui  t1, 0
  li   t2, 0
  bne t0, t1, .main_skip94226551604288
  li   t2, 1
.main_skip94226551604288:
  sw   t2, -172(s0)
  #   br i1 %logicalnot, label %and.rhs38, label %and.end39
  lw   t0, -172(s0)
  beqz t0, .if.merge35_br_false_path_94226551604728
  j .main_and.rhs38
.if.merge35_br_false_path_94226551604728:
  lui  t2, 0
  sw   t2, -184(s0)
  j .main_and.end39
.main_and.rhs38:
  #   %calltmp40 = call i32 @func(i32 100)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 100
  call func
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -176(s0)
  #   %tobool41 = icmp ne i32 %calltmp40, 0
  lw   t0, -176(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .main_skip94226551605024
  li   t2, 1
.main_skip94226551605024:
  sw   t2, -180(s0)
  #   br label %and.end39
  lw   t2, -180(s0)
  sw   t2, -184(s0)
  j .main_and.end39
.main_and.end39:
  #   %and.result42 = phi i1 [ false, %if.merge35 ], [ %tobool41, %and.rhs38 ]
  #   br i1 %and.result42, label %if.then43, label %if.else44
  lw   t0, -184(s0)
  beqz t0, .and.end39_br_false_path_94226551605896
  j .main_if.then43
.and.end39_br_false_path_94226551605896:
  j .main_if.else44
.main_if.then43:
  #   store i32 1, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   br label %if.merge45
  j .main_if.merge45
.main_if.else44:
  #   store i32 0, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %if.merge45
  j .main_if.merge45
.main_if.merge45:
  #   ret i32 0
  lui  a0, 0
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 188(sp)
  lw   s0, 184(sp)
  addi sp, sp, 192
  ret
