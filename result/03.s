.data

.text
.globl main
.type main, @function

main:
  # Function Prologue for main
  addi sp, sp, -128
  sw   ra, 124(sp)
  sw   s0, 120(sp)
  addi s0, sp, 128
.main_entry:
  #   %a = alloca i32
  #   store i32 0, i32* %a
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   %b = alloca i32
  #   store i32 8, i32* %b
  addi t1, s0, -52
  lui  t0, 0
  addi t0, t0, 8
  sw   t0, 0(t1)
  #   %c = alloca i32
  #   store i32 12, i32* %c
  addi t1, s0, -56
  lui  t0, 0
  addi t0, t0, 12
  sw   t0, 0(t1)
  #   %b.val = load i32, i32* %b
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   %c.val = load i32, i32* %c
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %add_tmp = add i32 %b.val, %c.val
  lw   t0, -60(s0)
  lw   t1, -64(s0)
  add t2, t0, t1
  sw   t2, -68(s0)
  #   store i32 %add_tmp, i32* %a
  addi t1, s0, -48
  lw   t0, -68(s0)
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* %a
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   ret i32 %a.val
  lw   a0, -72(s0)
  j    .main_epilogue
  #   %d = alloca i32
  #   store i32 9, i32* %d
  addi t1, s0, -76
  lui  t0, 0
  addi t0, t0, 9
  sw   t0, 0(t1)
  #   %a.val1 = load i32, i32* %a
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -80(s0)
  #   %d.val = load i32, i32* %d
  addi t0, s0, -76
  lw   t1, 0(t0)
  sw   t1, -84(s0)
  #   %mul_tmp = mul i32 %a.val1, %d.val
  lw   t0, -80(s0)
  lw   t1, -84(s0)
  mul t2, t0, t1
  sw   t2, -88(s0)
  #   store i32 %mul_tmp, i32* %a
  addi t1, s0, -48
  lw   t0, -88(s0)
  sw   t0, 0(t1)
  #   %a.val2 = load i32, i32* %a
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -92(s0)
  #   ret i32 %a.val2
  lw   a0, -92(s0)
  j    .main_epilogue
  #   %A = alloca i32
  #   store i32 4, i32* %A
  addi t1, s0, -96
  lui  t0, 0
  addi t0, t0, 4
  sw   t0, 0(t1)
  #   %A.val = load i32, i32* %A
  addi t0, s0, -96
  lw   t1, 0(t0)
  sw   t1, -100(s0)
  #   %b.val3 = load i32, i32* %b
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -104(s0)
  #   %sub_tmp = sub i32 %A.val, %b.val3
  lw   t0, -100(s0)
  lw   t1, -104(s0)
  sub t2, t0, t1
  sw   t2, -108(s0)
  #   %c.val4 = load i32, i32* %c
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -112(s0)
  #   %mul_tmp5 = mul i32 %sub_tmp, %c.val4
  lw   t0, -108(s0)
  lw   t1, -112(s0)
  mul t2, t0, t1
  sw   t2, -116(s0)
  #   store i32 %mul_tmp5, i32* %a
  addi t1, s0, -48
  lw   t0, -116(s0)
  sw   t0, 0(t1)
  #   %a.val6 = load i32, i32* %a
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -120(s0)
  #   ret i32 %a.val6
  lw   a0, -120(s0)
  j    .main_epilogue
  #   %a.val7 = load i32, i32* %a
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -124(s0)
  #   ret i32 %a.val7
  lw   a0, -124(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 124(sp)
  lw   s0, 120(sp)
  addi sp, sp, 128
  ret
