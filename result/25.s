.data
  .type a, @object
  .size a, 4
a:
  .word 0
  .type b, @object
  .size b, 4
b:
  .word 0

.text
.globl main
.type main, @function

main:
  # Function Prologue for main
  addi sp, sp, -96
  sw   ra, 92(sp)
  sw   s0, 88(sp)
  addi s0, sp, 96
.main_entry:
  #   %c = alloca i32
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
  #   store i32 %calltmp, i32* @a
  la   t1, a
  lw   t0, -52(s0)
  sw   t0, 0(t1)
  #   %calltmp1 = call i32 @get_int()
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
  sw   a0, -56(s0)
  #   store i32 %calltmp1, i32* @b
  la   t1, b
  lw   t0, -56(s0)
  sw   t0, 0(t1)
  #   store i32 0, i32* %c
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   %b.val = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %eqtmp = icmp eq i32 %a.val, %b.val
  lw   t0, -60(s0)
  lw   t1, -64(s0)
  li   t2, 0
  bne t0, t1, .main_skip94804228693920
  li   t2, 1
.main_skip94804228693920:
  sw   t2, -68(s0)
  #   br i1 %eqtmp, label %and.rhs, label %and.end
  lw   t0, -68(s0)
  beqz t0, .entry_br_false_path_94804228694312
  j .main_and.rhs
.entry_br_false_path_94804228694312:
  lui  t2, 0
  sw   t2, -80(s0)
  j .main_and.end
.main_and.rhs:
  #   %a.val2 = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   %netmp = icmp ne i32 %a.val2, 3
  lw   t0, -72(s0)
  lui  t1, 0
  addi t1, t1, 3
  li   t2, 0
  beq t0, t1, .main_skip94804228694608
  li   t2, 1
.main_skip94804228694608:
  sw   t2, -76(s0)
  #   br label %and.end
  lw   t2, -76(s0)
  sw   t2, -80(s0)
  j .main_and.end
.main_and.end:
  #   %and.result = phi i1 [ false, %entry ], [ %netmp, %and.rhs ]
  #   br i1 %and.result, label %if.then, label %if.else
  lw   t0, -80(s0)
  beqz t0, .and.end_br_false_path_94804228695896
  j .main_if.then
.and.end_br_false_path_94804228695896:
  j .main_if.else
.main_if.then:
  #   store i32 1, i32* %c
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   br label %if.merge
  j .main_if.merge
.main_if.else:
  #   store i32 0, i32* %c
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %if.merge
  j .main_if.merge
.main_if.merge:
  #   %c.val = load i32, i32* %c
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -84(s0)
  #   ret i32 %c.val
  lw   a0, -84(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 92(sp)
  lw   s0, 88(sp)
  addi sp, sp, 96
  ret
