.data

.text
.globl main
.type main, @function

main:
  # Function Prologue for main
  addi sp, sp, -48
  sw   ra, 44(sp)
  sw   s0, 40(sp)
  addi s0, sp, 48
.main_entry:
  #   ret i32 3
  lui  a0, 0
  addi a0, a0, 3
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 44(sp)
  lw   s0, 40(sp)
  addi sp, sp, 48
  ret
