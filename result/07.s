.data
  .type a, @object
  .size a, 20
a:
  .word 0
  .word 1
  .word 2
  .word 3
  .word 4

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
  #   %a.val = load i32, i32* getelementptr inbounds ([5 x i32], [5 x i32]* @a, i32 0, i32 4)
  la   t0, a
  addi t0, t0, 16
  lw   t1, 0(t0)
  sw   t1, -48(s0)
  #   ret i32 %a.val
  lw   a0, -48(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
