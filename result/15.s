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
  #   %a.val = load i32, i32* @a
  la   t0, a
  lw   t1, 0(t0)
  sw   t1, -48(s0)
  #   %div_tmp = sdiv i32 %a.val, 5
  lw   t0, -48(s0)
  lui  t1, 0
  addi t1, t1, 5
  div t2, t0, t1
  sw   t2, -52(s0)
  #   ret i32 %div_tmp
  lw   a0, -52(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
