.data
  .type a, @object
  .size a, 4
a:
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
  #   %p1 = alloca i32
  #   store i32 %p, i32* %p1
  addi t1, s0, -52
  lw   t0, -48(s0)
  sw   t0, 0(t1)
  #   %p.val = load i32, i32* %p1
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %sub_tmp = sub i32 %p.val, 1
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 1
  sub t2, t0, t1
  sw   t2, -60(s0)
  #   store i32 %sub_tmp, i32* %p1
  addi t1, s0, -52
  lw   t0, -60(s0)
  sw   t0, 0(t1)
  #   %p.val2 = load i32, i32* %p1
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   ret i32 %p.val2
  lw   a0, -64(s0)
  j    .func_epilogue
.func_epilogue:
  # Function Epilogue for func
  lw   ra, 76(sp)
  lw   s0, 72(sp)
  addi sp, sp, 80
  ret

main:
  # Function Prologue for main
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
.main_entry:
  #   %b = alloca i32
  #   store i32 0, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 10, i32* @a
  la   t1, a
  lui  t0, 0
  addi t0, t0, 10
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -52(s0)
  #   %calltmp = call i32 @func(i32 %a.val)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -52(s0)
  call func
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -56(s0)
  #   store i32 %calltmp, i32* %b
  addi t1, s0, -48
  lw   t0, -56(s0)
  sw   t0, 0(t1)
  #   %b.val = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   ret i32 %b.val
  lw   a0, -60(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
