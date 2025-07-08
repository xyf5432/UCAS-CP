.data

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
  #   store i32 10, i32* %a
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 10
  sw   t0, 0(t1)
  #   %b = alloca i32
  #   store i32 5, i32* %b
  addi t1, s0, -52
  lui  t0, 0
  addi t0, t0, 5
  sw   t0, 0(t1)
  #   %b.val = load i32, i32* %b
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   ret i32 %b.val
  lw   a0, -56(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
