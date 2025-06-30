.data
RADIUS:
  .word 0x40b00000
PI:
  .word 0x40490fdb
EPS:
  .word 0x358637bd
PI_HEX:
  .word 0x40490fdb
HEX2:
  .word 0x3da00000
FACT:
  .word 0xc700e800
CONV1:
  .word 0x43690000
CONV2:
  .word 0x457ff000
MAX:
  .word 1000000000
TWO:
  .word 2
THREE:
  .word 3

.text
.globl main

float_abs:
  # Function Prologue for float_abs
  addi sp, sp, -64
  sd   ra, 56(sp)
  sd   s0, 48(sp)
  addi s0, sp, 64
  sw   a0, -32(s0)
.float_abs_entry:
  #   %x1 = alloca float
  #   store float %x, float* %x1
  lw   t0, -32(s0)
  addi t1, s0, -36
  sw   t0, 0(t1)
  #   %x.val = load float, float* %x1
  addi t0, s0, -36
  lw   t1, 0(t0)
  sw   t1, -40(s0)
  #   %cmptmp = fcmp olt float %x.val, 0.000000e+00
  flw  ft0, -40(s0)
  li   t3, 0x0
  sw   t3, -32(s0)
  flw  ft1, -32(s0)
  flt.s t2, ft0, ft1
  sw   t2, -44(s0)
  #   br i1 %cmptmp, label %if.then, label %if.merge
  lw   t0, -44(s0)
  bnez t0, .float_abs_if.then
  j    .float_abs_if.merge
.float_abs_if.then:
  #   %x.val2 = load float, float* %x1
  addi t0, s0, -36
  lw   t1, 0(t0)
  sw   t1, -48(s0)
  #   %fneg = fneg float %x.val2
  flw  ft0, -48(s0)
  fneg.s ft1, ft0
  fsw  ft1, -52(s0)
  #   ret float %fneg
  lw   a0, -52(s0)
  j    .float_abs_epilogue
  #   br label %if.merge
  j    .float_abs_if.merge
.float_abs_if.merge:
  #   %x.val3 = load float, float* %x1
  addi t0, s0, -36
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   ret float %x.val3
  lw   a0, -56(s0)
  j    .float_abs_epilogue
.float_abs_epilogue:
  # Function Epilogue for float_abs
  ld   ra, 56(sp)
  ld   s0, 48(sp)
  addi sp, sp, 64
  ret

float_eq:
  # Function Prologue for float_eq
  addi sp, sp, -80
  sd   ra, 72(sp)
  sd   s0, 64(sp)
  addi s0, sp, 80
  sw   a0, -32(s0)
  sw   a1, -36(s0)
.float_eq_entry:
  #   %b2 = alloca float
  #   %a1 = alloca float
  #   store float %a, float* %a1
  lw   t0, -32(s0)
  addi t1, s0, -44
  sw   t0, 0(t1)
  #   store float %b, float* %b2
  lw   t0, -36(s0)
  addi t1, s0, -40
  sw   t0, 0(t1)
  #   %a.val = load float, float* %a1
  addi t0, s0, -44
  lw   t1, 0(t0)
  sw   t1, -48(s0)
  #   %b.val = load float, float* %b2
  addi t0, s0, -40
  lw   t1, 0(t0)
  sw   t1, -52(s0)
  #   %fsub_tmp = fsub float %a.val, %b.val
  flw  ft0, -48(s0)
  flw  ft1, -52(s0)
  fsub.s ft2, ft0, ft1
  fsw  ft2, -56(s0)
  #   %calltmp = call float @float_abs(float %fsub_tmp)
  lw   a0, -56(s0)
  call float_abs
  sw   a0, -60(s0)
  #   %EPS.val = load float, float* @EPS
  la   t0, EPS
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %cmptmp = fcmp olt float %calltmp, %EPS.val
  flw  ft0, -60(s0)
  flw  ft1, -64(s0)
  flt.s t2, ft0, ft1
  sw   t2, -68(s0)
  #   br i1 %cmptmp, label %if.then, label %if.else
  lw   t0, -68(s0)
  bnez t0, .float_eq_if.then
  j    .float_eq_if.else
.float_eq_if.then:
  #   ret i32 1
  li   a0, 1
  j    .float_eq_epilogue
  #   br label %if.merge
  j    .float_eq_if.merge
.float_eq_if.else:
  #   ret i32 0
  li   a0, 0
  j    .float_eq_epilogue
  #   br label %if.merge
  j    .float_eq_if.merge
.float_eq_if.merge:
.float_eq_epilogue:
  # Function Epilogue for float_eq
  ld   ra, 72(sp)
  ld   s0, 64(sp)
  addi sp, sp, 80
  ret

error:
  # Function Prologue for error
  addi sp, sp, -32
  sd   ra, 24(sp)
  sd   s0, 16(sp)
  addi s0, sp, 32
.error_entry:
  #   call void @print_char(i8 101)
  li   a0, 101
  call print_char
  #   call void @print_char(i8 114)
  li   a0, 114
  call print_char
  #   call void @print_char(i8 114)
  li   a0, 114
  call print_char
  #   call void @print_char(i8 111)
  li   a0, 111
  call print_char
  #   call void @print_char(i8 114)
  li   a0, 114
  call print_char
  #   call void @print_char(i8 92)
  li   a0, 92
  call print_char
.error_epilogue:
  # Function Epilogue for error
  ld   ra, 24(sp)
  ld   s0, 16(sp)
  addi sp, sp, 32
  ret

ok:
  # Function Prologue for ok
  addi sp, sp, -32
  sd   ra, 24(sp)
  sd   s0, 16(sp)
  addi s0, sp, 32
.ok_entry:
  #   call void @print_char(i8 111)
  li   a0, 111
  call print_char
  #   call void @print_char(i8 107)
  li   a0, 107
  call print_char
  #   call void @print_char(i8 92)
  li   a0, 92
  call print_char
.ok_epilogue:
  # Function Epilogue for ok
  ld   ra, 24(sp)
  ld   s0, 16(sp)
  addi sp, sp, 32
  ret

assert:
  # Function Prologue for assert
  addi sp, sp, -48
  sd   ra, 40(sp)
  sd   s0, 32(sp)
  addi s0, sp, 48
  sw   a0, -32(s0)
.assert_entry:
  #   %cond1 = alloca i32
  #   store i32 %cond, i32* %cond1
  lw   t0, -32(s0)
  addi t1, s0, -36
  sw   t0, 0(t1)
  #   %cond.val = load i32, i32* %cond1
  addi t0, s0, -36
  lw   t1, 0(t0)
  sw   t1, -40(s0)
  #   %eqtmp = icmp eq i32 %cond.val, 0
  lw   t0, -40(s0)
  li   t1, 0
  li   t2, 0
  bne t0, t1, .assert_skip38644736
  li   t2, 1
.assert_skip38644736:
  sw   t2, -44(s0)
  #   br i1 %eqtmp, label %if.then, label %if.else
  lw   t0, -44(s0)
  bnez t0, .assert_if.then
  j    .assert_if.else
.assert_if.then:
  #   call void @error()
  call error
  #   br label %if.merge
  j    .assert_if.merge
.assert_if.else:
  #   call void @ok()
  call ok
  #   br label %if.merge
  j    .assert_if.merge
.assert_if.merge:
.assert_epilogue:
  # Function Epilogue for assert
  ld   ra, 40(sp)
  ld   s0, 32(sp)
  addi sp, sp, 48
  ret

assert_not:
  # Function Prologue for assert_not
  addi sp, sp, -48
  sd   ra, 40(sp)
  sd   s0, 32(sp)
  addi s0, sp, 48
  sw   a0, -32(s0)
.assert_not_entry:
  #   %cond1 = alloca i32
  #   store i32 %cond, i32* %cond1
  lw   t0, -32(s0)
  addi t1, s0, -36
  sw   t0, 0(t1)
  #   %cond.val = load i32, i32* %cond1
  addi t0, s0, -36
  lw   t1, 0(t0)
  sw   t1, -40(s0)
  #   %tobool = icmp ne i32 %cond.val, 0
  lw   t0, -40(s0)
  li   t1, 0
  li   t2, 0
  beq t0, t1, .assert_not_skip38647328
  li   t2, 1
.assert_not_skip38647328:
  sw   t2, -44(s0)
  #   br i1 %tobool, label %if.then, label %if.else
  lw   t0, -44(s0)
  bnez t0, .assert_not_if.then
  j    .assert_not_if.else
.assert_not_if.then:
  #   call void @error()
  call error
  #   br label %if.merge
  j    .assert_not_if.merge
.assert_not_if.else:
  #   call void @ok()
  call ok
  #   br label %if.merge
  j    .assert_not_if.merge
.assert_not_if.merge:
.assert_not_epilogue:
  # Function Epilogue for assert_not
  ld   ra, 40(sp)
  ld   s0, 32(sp)
  addi sp, sp, 48
  ret

main:
  # Function Prologue for main
  addi sp, sp, -176
  sd   ra, 168(sp)
  sd   s0, 160(sp)
  addi s0, sp, 176
.main_entry:
  #   %EVAL1 = alloca float
  #   store float 0.000000e+00, float* %EVAL1
  li   t0, 0x0
  addi t1, s0, -32
  sw   t0, 0(t1)
  #   %PI.val = load float, float* @PI
  la   t0, PI
  lw   t1, 0(t0)
  sw   t1, -36(s0)
  #   %RADIUS.val = load float, float* @RADIUS
  la   t0, RADIUS
  lw   t1, 0(t0)
  sw   t1, -40(s0)
  #   %fmul_tmp = fmul float %PI.val, %RADIUS.val
  flw  ft0, -36(s0)
  flw  ft1, -40(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -44(s0)
  #   %RADIUS.val1 = load float, float* @RADIUS
  la   t0, RADIUS
  lw   t1, 0(t0)
  sw   t1, -48(s0)
  #   %fmul_tmp2 = fmul float %fmul_tmp, %RADIUS.val1
  flw  ft0, -44(s0)
  flw  ft1, -48(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -52(s0)
  #   store float %fmul_tmp2, float* %EVAL1
  lw   t0, -52(s0)
  addi t1, s0, -32
  sw   t0, 0(t1)
  #   %EVAL2 = alloca float
  #   store float 2.000000e+00, float* %EVAL2
  li   t0, 0x40000000
  addi t1, s0, -56
  sw   t0, 0(t1)
  #   %EVAL2.val = load float, float* %EVAL2
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -60(s0)
  #   %PI_HEX.val = load float, float* @PI_HEX
  la   t0, PI_HEX
  lw   t1, 0(t0)
  sw   t1, -64(s0)
  #   %fmul_tmp3 = fmul float %EVAL2.val, %PI_HEX.val
  flw  ft0, -60(s0)
  flw  ft1, -64(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -68(s0)
  #   %RADIUS.val4 = load float, float* @RADIUS
  la   t0, RADIUS
  lw   t1, 0(t0)
  sw   t1, -72(s0)
  #   %fmul_tmp5 = fmul float %fmul_tmp3, %RADIUS.val4
  flw  ft0, -68(s0)
  flw  ft1, -72(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -76(s0)
  #   store float %fmul_tmp5, float* %EVAL2
  lw   t0, -76(s0)
  addi t1, s0, -56
  sw   t0, 0(t1)
  #   %EVAL3 = alloca float
  #   store float 2.000000e+00, float* %EVAL3
  li   t0, 0x40000000
  addi t1, s0, -80
  sw   t0, 0(t1)
  #   %PI.val6 = load float, float* @PI
  la   t0, PI
  lw   t1, 0(t0)
  sw   t1, -84(s0)
  #   %EVAL3.val = load float, float* %EVAL3
  addi t0, s0, -80
  lw   t1, 0(t0)
  sw   t1, -88(s0)
  #   %fmul_tmp7 = fmul float %PI.val6, %EVAL3.val
  flw  ft0, -84(s0)
  flw  ft1, -88(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -92(s0)
  #   %RADIUS.val8 = load float, float* @RADIUS
  la   t0, RADIUS
  lw   t1, 0(t0)
  sw   t1, -96(s0)
  #   %fmul_tmp9 = fmul float %fmul_tmp7, %RADIUS.val8
  flw  ft0, -92(s0)
  flw  ft1, -96(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -100(s0)
  #   store float %fmul_tmp9, float* %EVAL3
  lw   t0, -100(s0)
  addi t1, s0, -80
  sw   t0, 0(t1)
  #   %FIVE = alloca i32
  #   store i32 0, i32* %FIVE
  li   t0, 0
  addi t1, s0, -104
  sw   t0, 0(t1)
  #   %TWO.val = load i32, i32* @TWO
  la   t0, TWO
  lw   t1, 0(t0)
  sw   t1, -108(s0)
  #   %THREE.val = load i32, i32* @THREE
  la   t0, THREE
  lw   t1, 0(t0)
  sw   t1, -112(s0)
  #   %add_tmp = add i32 %TWO.val, %THREE.val
  lw   t0, -108(s0)
  lw   t1, -112(s0)
  add t2, t0, t1
  sw   t2, -116(s0)
  #   store i32 %add_tmp, i32* %FIVE
  lw   t0, -116(s0)
  addi t1, s0, -104
  sw   t0, 0(t1)
  #   %HEX2.val = load float, float* @HEX2
  la   t0, HEX2
  lw   t1, 0(t0)
  sw   t1, -120(s0)
  #   %FACT.val = load float, float* @FACT
  la   t0, FACT
  lw   t1, 0(t0)
  sw   t1, -124(s0)
  #   %calltmp = call i32 @float_eq(float %HEX2.val, float %FACT.val)
  lw   a0, -120(s0)
  lw   a1, -124(s0)
  call float_eq
  sw   a0, -128(s0)
  #   call void @assert_not(i32 %calltmp)
  lw   a0, -128(s0)
  call assert_not
  #   %EVAL1.val = load float, float* %EVAL1
  addi t0, s0, -32
  lw   t1, 0(t0)
  sw   t1, -132(s0)
  #   %EVAL2.val10 = load float, float* %EVAL2
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -136(s0)
  #   %calltmp11 = call i32 @float_eq(float %EVAL1.val, float %EVAL2.val10)
  lw   a0, -132(s0)
  lw   a1, -136(s0)
  call float_eq
  sw   a0, -140(s0)
  #   call void @assert_not(i32 %calltmp11)
  lw   a0, -140(s0)
  call assert_not
  #   %EVAL2.val12 = load float, float* %EVAL2
  addi t0, s0, -56
  lw   t1, 0(t0)
  sw   t1, -144(s0)
  #   %EVAL3.val13 = load float, float* %EVAL3
  addi t0, s0, -80
  lw   t1, 0(t0)
  sw   t1, -148(s0)
  #   %calltmp14 = call i32 @float_eq(float %EVAL2.val12, float %EVAL3.val13)
  lw   a0, -144(s0)
  lw   a1, -148(s0)
  call float_eq
  sw   a0, -152(s0)
  #   call void @assert(i32 %calltmp14)
  lw   a0, -152(s0)
  call assert
  #   %CONV1.val = load float, float* @CONV1
  la   t0, CONV1
  lw   t1, 0(t0)
  sw   t1, -156(s0)
  #   %CONV2.val = load float, float* @CONV2
  la   t0, CONV2
  lw   t1, 0(t0)
  sw   t1, -160(s0)
  #   %calltmp15 = call i32 @float_eq(float %CONV1.val, float %CONV2.val)
  lw   a0, -156(s0)
  lw   a1, -160(s0)
  call float_eq
  sw   a0, -164(s0)
  #   call void @assert_not(i32 %calltmp15)
  lw   a0, -164(s0)
  call assert_not
  #   ret i32 0
  li   a0, 0
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  ld   ra, 168(sp)
  ld   s0, 160(sp)
  addi sp, sp, 176
  ret
