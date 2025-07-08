.data

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
  #   %sum = alloca i32
  #   %i = alloca i32
  #   store i32 0, i32* %i
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %i
  addi t1, s0, -52
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %sum
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   store i32 0, i32* %sum
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_while.cond:
  #   %i.val = load i32, i32* %i
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %cmptmp = icmp slt i32 %i.val, 100
  lw   t0, -56(s0)
  lui  t1, 0
  addi t1, t1, 100
  li   t2, 0
  bge t0, t1, .main_skip94074717260384
  li   t2, 1
.main_skip94074717260384:
  sw   t2, -60(s0)
  #   br i1 %cmptmp, label %while.body, label %while.end
  lw   t0, -60(s0)
  beqz t0, .while.cond_br_false_path_94074717285608
  j .main_while.body
.while.cond_br_false_path_94074717285608:
  j .main_while.end
.main_while.body:
  #   %i.val1 = load i32, i32* %i
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %eqtmp = icmp eq i32 %i.val1, 50
  lw   t0, -64(s0)
  lui  t1, 0
  addi t1, t1, 50
  li   t2, 0
  bne t0, t1, .main_skip94074717259904
  li   t2, 1
.main_skip94074717259904:
  sw   t2, -68(s0)
  #   br i1 %eqtmp, label %if.then, label %if.merge
  lw   t0, -68(s0)
  beqz t0, .while.body_br_false_path_94074717286936
  j .main_if.then
.while.body_br_false_path_94074717286936:
  j .main_if.merge
.main_if.then:
  #   %i.val2 = load i32, i32* %i
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   %add_tmp = add i32 %i.val2, 1
  lw   t0, -72(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -76(s0)
  #   store i32 %add_tmp, i32* %i
  addi t1, s0, -52
  lw   t0, -76(s0)
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
  #   br label %if.merge
  j .main_if.merge
.main_if.merge:
  #   %sum.val = load i32, i32* %sum
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -80(s0)
  #   %i.val3 = load i32, i32* %i
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -84(s0)
  #   %add_tmp4 = add i32 %sum.val, %i.val3
  lw   t0, -80(s0)
  lw   t1, -84(s0)
  add t2, t0, t1
  sw   t2, -88(s0)
  #   store i32 %add_tmp4, i32* %sum
  addi t1, s0, -48
  lw   t0, -88(s0)
  sw   t0, 0(t1)
  #   %i.val5 = load i32, i32* %i
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -92(s0)
  #   %add_tmp6 = add i32 %i.val5, 1
  lw   t0, -92(s0)
  lui  t1, 0
  addi t1, t1, 1
  add t2, t0, t1
  sw   t2, -96(s0)
  #   store i32 %add_tmp6, i32* %i
  addi t1, s0, -52
  lw   t0, -96(s0)
  sw   t0, 0(t1)
  #   br label %while.cond
  j .main_while.cond
.main_while.end:
  #   %sum.val7 = load i32, i32* %sum
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -100(s0)
  #   %mod_tmp = srem i32 %sum.val7, 256
  lw   t0, -100(s0)
  lui  t1, 0
  addi t1, t1, 256
  rem t2, t0, t1
  sw   t2, -104(s0)
  #   ret i32 %mod_tmp
  lw   a0, -104(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 108(sp)
  lw   s0, 104(sp)
  addi sp, sp, 112
  ret
