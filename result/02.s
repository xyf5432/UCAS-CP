.data

.text
.globl main
.type main, @function

main:
  # Function Prologue for main
  addi sp, sp, -80
  sw   ra, 76(sp)
  sw   s0, 72(sp)
  addi s0, sp, 80
.main_entry:
  #   %c = alloca i32
  #   %b = alloca i32
  #   %a = alloca i32
  #   store i32 0, i32* %a
  addi t1, s0, -56
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %b
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %c
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 1, i32* %a
  addi t1, s0, -56
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   store i32 2, i32* %b
  addi t1, s0, -52
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   store i32 3, i32* %c
  addi t1, s0, -48
  lui  t0, 0
  addi t0, t0, 3
  sw   t0, 0(t1)
  #   %b.val = load i32, i32* %b
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   %c.val = load i32, i32* %c
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %add_tmp = add i32 %b.val, %c.val
  lw   t0, -60(s0)
  lw   t1, -64(s0)
  add t2, t0, t1
  sw   t2, -68(s0)
  #   ret i32 %add_tmp
  lw   a0, -68(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 76(sp)
  lw   s0, 72(sp)
  addi sp, sp, 80
  ret
