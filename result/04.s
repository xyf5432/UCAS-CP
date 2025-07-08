.data

.text
.globl main
.type main, @function

main:
  # Function Prologue for main
  addi sp, sp, -448
  sw   ra, 444(sp)
  sw   s0, 440(sp)
  addi s0, sp, 448
.main_entry:
  #   %a = alloca [4 x [2 x i32]]
  #   %array.elem = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 0, i32 0
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -80(s0)
  #   store i32 0, i32* %array.elem
  lw   t1, -80(s0)
  lui  t0, 0
  sw   t0, 0(t1)
  #   %array.elem1 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 1, i32 0
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -88(s0)
  #   store i32 0, i32* %array.elem1
  lw   t1, -88(s0)
  lui  t0, 0
  sw   t0, 0(t1)
  #   %array.elem2 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 2, i32 0
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 2
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -96(s0)
  #   store i32 0, i32* %array.elem2
  lw   t1, -96(s0)
  lui  t0, 0
  sw   t0, 0(t1)
  #   %array.elem3 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 3, i32 0
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 3
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -104(s0)
  #   store i32 0, i32* %array.elem3
  lw   t1, -104(s0)
  lui  t0, 0
  sw   t0, 0(t1)
  #   %array.elem4 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 0, i32 1
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -112(s0)
  #   store i32 0, i32* %array.elem4
  lw   t1, -112(s0)
  lui  t0, 0
  sw   t0, 0(t1)
  #   %array.elem5 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 1, i32 1
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -120(s0)
  #   store i32 0, i32* %array.elem5
  lw   t1, -120(s0)
  lui  t0, 0
  sw   t0, 0(t1)
  #   %array.elem6 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 2, i32 1
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 2
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -128(s0)
  #   store i32 0, i32* %array.elem6
  lw   t1, -128(s0)
  lui  t0, 0
  sw   t0, 0(t1)
  #   %array.elem7 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 3, i32 1
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 3
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -136(s0)
  #   store i32 0, i32* %array.elem7
  lw   t1, -136(s0)
  lui  t0, 0
  sw   t0, 0(t1)
  #   %c = alloca [4 x [2 x i32]]
  #   %array.elem8 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 0, i32 0
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -176(s0)
  #   store i32 1, i32* %array.elem8
  lw   t1, -176(s0)
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   %array.elem9 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 0, i32 1
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -184(s0)
  #   store i32 2, i32* %array.elem9
  lw   t1, -184(s0)
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   %array.elem10 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 1, i32 0
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -192(s0)
  #   store i32 3, i32* %array.elem10
  lw   t1, -192(s0)
  lui  t0, 0
  addi t0, t0, 3
  sw   t0, 0(t1)
  #   %array.elem11 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 1, i32 1
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -200(s0)
  #   store i32 4, i32* %array.elem11
  lw   t1, -200(s0)
  lui  t0, 0
  addi t0, t0, 4
  sw   t0, 0(t1)
  #   %array.elem12 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 2, i32 0
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 2
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -208(s0)
  #   store i32 5, i32* %array.elem12
  lw   t1, -208(s0)
  lui  t0, 0
  addi t0, t0, 5
  sw   t0, 0(t1)
  #   %array.elem13 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 2, i32 1
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 2
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -216(s0)
  #   store i32 6, i32* %array.elem13
  lw   t1, -216(s0)
  lui  t0, 0
  addi t0, t0, 6
  sw   t0, 0(t1)
  #   %array.elem14 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 3, i32 0
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 3
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -224(s0)
  #   store i32 7, i32* %array.elem14
  lw   t1, -224(s0)
  lui  t0, 0
  addi t0, t0, 7
  sw   t0, 0(t1)
  #   %array.elem15 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 3, i32 1
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 3
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -232(s0)
  #   store i32 8, i32* %array.elem15
  lw   t1, -232(s0)
  lui  t0, 0
  addi t0, t0, 8
  sw   t0, 0(t1)
  #   %e = alloca [4 x [2 x i32]]
  #   %array.elem16 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 0, i32 0
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -272(s0)
  #   store i32 1, i32* %array.elem16
  lw   t1, -272(s0)
  lui  t0, 0
  addi t0, t0, 1
  sw   t0, 0(t1)
  #   %array.elem17 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 0, i32 1
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -280(s0)
  #   store i32 2, i32* %array.elem17
  lw   t1, -280(s0)
  lui  t0, 0
  addi t0, t0, 2
  sw   t0, 0(t1)
  #   %array.elem18 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 1, i32 0
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -288(s0)
  #   store i32 3, i32* %array.elem18
  lw   t1, -288(s0)
  lui  t0, 0
  addi t0, t0, 3
  sw   t0, 0(t1)
  #   %array.elem19 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 1, i32 1
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -296(s0)
  #   store i32 4, i32* %array.elem19
  lw   t1, -296(s0)
  lui  t0, 0
  addi t0, t0, 4
  sw   t0, 0(t1)
  #   %array.elem20 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 2, i32 0
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 2
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -304(s0)
  #   store i32 5, i32* %array.elem20
  lw   t1, -304(s0)
  lui  t0, 0
  addi t0, t0, 5
  sw   t0, 0(t1)
  #   %array.elem21 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 2, i32 1
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 2
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -312(s0)
  #   store i32 6, i32* %array.elem21
  lw   t1, -312(s0)
  lui  t0, 0
  addi t0, t0, 6
  sw   t0, 0(t1)
  #   %array.elem22 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 3, i32 0
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 3
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -320(s0)
  #   store i32 7, i32* %array.elem22
  lw   t1, -320(s0)
  lui  t0, 0
  addi t0, t0, 7
  sw   t0, 0(t1)
  #   %array.elem23 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 3, i32 1
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 3
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -328(s0)
  #   store i32 8, i32* %array.elem23
  lw   t1, -328(s0)
  lui  t0, 0
  addi t0, t0, 8
  sw   t0, 0(t1)
  #   %arrayidx = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 0, i32 0
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -336(s0)
  #   %arrayidx24 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 2, i32 1
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 2
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -344(s0)
  #   %c.val = load i32, i32* %arrayidx24
  lw   t0, -344(s0)
  lw   t1, 0(t0)
  sw   t1, -352(s0)
  #   store i32 %c.val, i32* %arrayidx
  lw   t1, -336(s0)
  lw   t0, -352(s0)
  sw   t0, 0(t1)
  #   %arrayidx25 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 0, i32 1
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -356(s0)
  #   %arrayidx26 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %c, i32 0, i32 1, i32 1
  addi t0, s0, -144
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -364(s0)
  #   %c.val27 = load i32, i32* %arrayidx26
  lw   t0, -364(s0)
  lw   t1, 0(t0)
  sw   t1, -372(s0)
  #   store i32 %c.val27, i32* %arrayidx25
  lw   t1, -356(s0)
  lw   t0, -372(s0)
  sw   t0, 0(t1)
  #   %arrayidx28 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 3, i32 1
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 3
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -376(s0)
  #   %e.val = load i32, i32* %arrayidx28
  lw   t0, -376(s0)
  lw   t1, 0(t0)
  sw   t1, -384(s0)
  #   %arrayidx29 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 0, i32 0
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -388(s0)
  #   %e.val30 = load i32, i32* %arrayidx29
  lw   t0, -388(s0)
  lw   t1, 0(t0)
  sw   t1, -396(s0)
  #   %add_tmp = add i32 %e.val, %e.val30
  lw   t0, -384(s0)
  lw   t1, -396(s0)
  add t2, t0, t1
  sw   t2, -400(s0)
  #   %arrayidx31 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %e, i32 0, i32 0, i32 1
  addi t0, s0, -240
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 1
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -404(s0)
  #   %e.val32 = load i32, i32* %arrayidx31
  lw   t0, -404(s0)
  lw   t1, 0(t0)
  sw   t1, -412(s0)
  #   %add_tmp33 = add i32 %add_tmp, %e.val32
  lw   t0, -400(s0)
  lw   t1, -412(s0)
  add t2, t0, t1
  sw   t2, -416(s0)
  #   %arrayidx34 = getelementptr inbounds [4 x [2 x i32]], [4 x [2 x i32]]* %a, i32 0, i32 2, i32 0
  addi t0, s0, -48
  li   t3, 0
  lui  t1, 0
  li   t2, 32
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  addi t1, t1, 2
  li   t2, 8
  mul  t1, t1, t2
  add  t3, t3, t1
  lui  t1, 0
  li   t2, 4
  mul  t1, t1, t2
  add  t3, t3, t1
  add  t0, t0, t3
  sw   t0, -420(s0)
  #   %a.val = load i32, i32* %arrayidx34
  lw   t0, -420(s0)
  lw   t1, 0(t0)
  sw   t1, -428(s0)
  #   %add_tmp35 = add i32 %add_tmp33, %a.val
  lw   t0, -416(s0)
  lw   t1, -428(s0)
  add t2, t0, t1
  sw   t2, -432(s0)
  #   ret i32 %add_tmp35
  lw   a0, -432(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 444(sp)
  lw   s0, 440(sp)
  addi sp, sp, 448
  ret
