.data
  .type a, @object
  .size a, 4
a:
  .word 10
  .type b, @object
  .size b, 4
b:
  .word 5

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
  #   %b.val = load i32, i32* @b
  la   t0, b
  lw   t1, 0(t0)
  sw   t1, -48(s0)
  #   ret i32 %b.val
  lw   a0, -48(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
