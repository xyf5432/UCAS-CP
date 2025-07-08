.data
  .type arr, @object
  .size arr, 24
arr:
  .word 1
  .word 2
  .word 33
  .word 4
  .word 5
  .word 6

.text
.globl main
.type main, @function

main:
  # Function Prologue for main
  addi sp, sp, -112
  sw   ra, 108(sp)
  sw   s0, 104(sp)
  addi s0, sp, 112
.main_entry:
  #   %i = alloca i32
  #   store i32 0, i32* %i
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   %sum = alloca i32
  #   store i32 0, i32* %sum
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_while.cond:
  #   %i.val = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %cmptmp = icmp slt i32 %i.val, 6
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 6
  li   t2, 0
  bge t0, t1, .main_skip94383038534976
  li   t2, 1
.main_skip94383038534976:
  sw   t2, -60(s0)
  #   br i1 %cmptmp, label %while.body, label %while.end
  lw   t0, -60(s0)
  beqz t0, .while.cond_br_false_path_94383038535144
  j .main_while.body
.while.cond_br_false_path_94383038535144:
  j .main_while.end
.main_while.body:
  #   %sum.val = load i32, i32* %sum
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %i.val1 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -68(s0)
  #   %arrayidx = getelementptr inbounds [6 x i32], [6 x i32]* @arr, i32 0, i32 %i.val1
  la   t0, arr
  li   t3, 0
  lui  t1, 0
  li   t2, 24
  mul  t1, t1, t2
  add  t3, t3, t1
  lw   t1, -68(s0)
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -72(s0)
  #   %arr.val = load i32, i32* %arrayidx
  lw   t0, -72(s0)
  lw   t1, 0(t0)
  sw   t1, -80(s0)
  #   %add_tmp = add i32 %sum.val, %arr.val
  lw   t0, -64(s0)
  lw   t1, -80(s0)
  add t2, t0, t1
  sw   t2, -84(s0)
  #   store i32 %add_tmp, i32* %sum
  addi t1, s0, -52
  lw   t0, -84(s0)
  sw   t0, 0(t1)
  #   %i.val2 = load i32, i32* %i
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -88(s0)
  #   %add_tmp3 = add i32 %i.val2, 1
  lw   t0, -88(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -92(s0)
  #   store i32 %add_tmp3, i32* %i
  addi t1, s0, -48
  lw   t0, -92(s0)
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_while.end:
  #   %sum.val4 = load i32, i32* %sum
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -96(s0)
  #   ret i32 %sum.val4
  lw   a0, -96(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 108(sp)
  lw   s0, 104(sp)
  addi sp, sp, 112
  ret
