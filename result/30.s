.data
  .type a, @object
  .size a, 4
a:
  .word 7

.text
.globl main
.type main, @function

func:
  # Function Prologue for func
  addi sp, sp, -80
  sw   ra, 76(sp)
  sw   s0, 72(sp)
  addi s0, sp, 80
.func_entry:
  #   %b = alloca i32
  #   store i32 -1, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, -1
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -52(s0)
  #   store i32 %a.val, i32* %b
  addi t1, s0, -48
  lw   t0, -52(s0)
  sw   t0, 0(t1)
  #   %a = alloca i32
  #   store i32 1, i32* %a
  addi t1, s0, -56
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   %a.val1 = load i32, i32* %a
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   %b.val = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %eqtmp = icmp eq i32 %a.val1, %b.val
  lw   t0, -60(s0)
  lw   t1, -64(s0)
  li   t2, 0
  bne t0, t1, .func_skip94468550063536
  li   t2, 1
.func_skip94468550063536:
  sw   t2, -68(s0)
  #   br i1 %eqtmp, label %if.then, label %if.else
  lw   t0, -68(s0)
  beqz t0, .entry_br_false_path_94468550116376
  j .func_if.then
.entry_br_false_path_94468550116376:
  j .func_if.else
.func_if.then:
  #   %a.val2 = load i32, i32* %a
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   %add_tmp = add i32 %a.val2, 1
  lw   t0, -72(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -76(s0)
  #   store i32 %add_tmp, i32* %a
  addi t1, s0, -56
  lw   t0, -76(s0)
  sw   t0, 0(t1)
  #   ret i32 1
  lui  a0, 0
  addi a0, a0, 1
  j    .func_epilogue
  #   br label %if.merge
  j .func_if.merge
.func_if.else:
  #   ret i32 0
  lui  a0, 0
  j    .func_epilogue
  #   br label %if.merge
  j .func_if.merge
.func_if.merge:
.func_epilogue:
  # Function Epilogue for func
  lw   ra, 76(sp)
  lw   s0, 72(sp)
  addi sp, sp, 80
  ret

main:
  # Function Prologue for main
  addi sp, sp, -96
  sw   ra, 92(sp)
  sw   s0, 88(sp)
  addi s0, sp, 96
.main_entry:
  #   %result = alloca i32
  #   store i32 0, i32* %result
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   %i = alloca i32
  #   store i32 0, i32* %i
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_while.cond:
  #   %i.val = load i32, i32* %i
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %cmptmp = icmp slt i32 %i.val, 100
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 100
  li   t2, 0
  bge t0, t1, .main_skip94468550063424
  li   t2, 1
.main_skip94468550063424:
  sw   t2, -60(s0)
  #   br i1 %cmptmp, label %while.body, label %while.end
  lw   t0, -60(s0)
  beqz t0, .while.cond_br_false_path_94468550123752
  j .main_while.body
.while.cond_br_false_path_94468550123752:
  j .main_while.end
.main_while.body:
  #   %calltmp = call i32 @func()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call func
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -64(s0)
  #   %eqtmp = icmp eq i32 %calltmp, 1
  lw   t0, -64(s0)
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 0
  bne t0, t1, .main_skip94468550124144
  li   t2, 1
.main_skip94468550124144:
  sw   t2, -68(s0)
  #   br i1 %eqtmp, label %if.then, label %if.merge
  lw   t0, -68(s0)
  beqz t0, .while.body_br_false_path_94468550124504
  j .main_if.then
.while.body_br_false_path_94468550124504:
  j .main_if.merge
.main_if.then:
  #   %result.val = load i32, i32* %result
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   %add_tmp = add i32 %result.val, 1
  lw   t0, -72(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -76(s0)
  #   store i32 %add_tmp, i32* %result
  addi t1, s0, -48
  lw   t0, -76(s0)
  sw   t0, 0(t1)
  #   br label %if.merge
  j .main_if.merge
.main_if.merge:
  #   %i.val1 = load i32, i32* %i
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -80(s0)
  #   %add_tmp2 = add i32 %i.val1, 1
  lw   t0, -80(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -84(s0)
  #   store i32 %add_tmp2, i32* %i
  addi t1, s0, -52
  lw   t0, -84(s0)
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_while.end:
  #   %result.val3 = load i32, i32* %result
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -88(s0)
  #   %cmptmp4 = icmp slt i32 %result.val3, 100
  lw   t0, -88(s0)
  lui  t1, 0
  addi t1, t1, 100
  li   t2, 0
  bge t0, t1, .main_skip94468550126208
  li   t2, 1
.main_skip94468550126208:
  sw   t2, -92(s0)
  #   br i1 %cmptmp4, label %if.then5, label %if.else
  lw   t0, -92(s0)
  beqz t0, .while.end_br_false_path_94468550123944
  j .main_if.then5
.while.end_br_false_path_94468550123944:
  j .main_if.else
.main_if.then5:
  #   call void @print_int(i32 1)
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
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge6
  j .main_if.merge6
.main_if.else:
  #   call void @print_int(i32 0)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  call print_int
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge6
  j .main_if.merge6
.main_if.merge6:
  #   ret i32 0
  lui  a0, 0
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 92(sp)
  lw   s0, 88(sp)
  addi sp, sp, 96
  ret
