.data
  .type a, @object
  .size a, 4
a:
  .word 10

.text
.globl main
.type main, @function

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
  #   store i32 2, i32* %b
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -52(s0)
  #   %b.val = load i32, i32* %b
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %sub_tmp = sub i32 %a.val, %b.val
  lw   t0, -52(s0)
  lw   t1, -56(s0)
  sub t2, t0, t1
  sw   t2, -60(s0)
  #   ret i32 %sub_tmp
  lw   a0, -60(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
