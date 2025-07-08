.data
  .type a, @object
  .size a, 4
a:
  .word 2
  .type b, @object
  .size b, 4
b:
  .word 3

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
  #   %a = alloca i32
  #   store i32 4, i32* %a
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 4
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* %a
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -52(s0)
  #   %b.val = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %add_tmp = add i32 %a.val, %b.val
  lw   t0, -52(s0)
  lw   t1, -56(s0)
  add t2, t0, t1
  sw   t2, -60(s0)
  #   ret i32 %add_tmp
  lw   a0, -60(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
