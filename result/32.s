.data
  .type RADIUS, @object
  .size RADIUS, 4
RADIUS:
  .word 0x40b00000
  .type PI, @object
  .size PI, 4
PI:
  .word 0x40490fdb
  .type EPS, @object
  .size EPS, 4
EPS:
  .word 0x358637bd
  .type PI_HEX, @object
  .size PI_HEX, 4
PI_HEX:
  .word 0x40490fdb
  .type HEX2, @object
  .size HEX2, 4
HEX2:
  .word 0x3da00000
  .type FACT, @object
  .size FACT, 4
FACT:
  .word 0xc700e800
  .type CONV1, @object
  .size CONV1, 4
CONV1:
  .word 0x43690000
  .type CONV2, @object
  .size CONV2, 4
CONV2:
  .word 0x457ff000
  .type MAX, @object
  .size MAX, 4
MAX:
  .word 1000000000
  .type TWO, @object
  .size TWO, 4
TWO:
  .word 2
  .type THREE, @object
  .size THREE, 4
THREE:
  .word 3

.text
.globl main
.type main, @function

float_abs:
  # Function Prologue for float_abs
  addi sp, sp, -80
  sw   ra, 76(sp)
  sw   s0, 72(sp)
  addi s0, sp, 80
  fsw  fa0, -48(s0)
.float_abs_entry:
  #   %x1 = alloca float
  #   store float %x, float* %x1
  addi t1, s0, -52
  flw  ft0, -48(s0)
  fsw  ft0, 0(t1)
  #   %x.val = load float, float* %x1
  addi t0, s0, -52
  flw  ft0, 0(t0)
  fsw  ft0, -56(s0)
  #   %cmptmp = fcmp olt float %x.val, 0.000000e+00
  flw  ft0, -56(s0)
  lui  t3, 0
  addi t3, t3, 0
  sw   t3, -32(s0)
  flw  ft1, -32(s0)
  flt.s t2, ft0, ft1
  sw   t2, -60(s0)
  #   br i1 %cmptmp, label %if.then, label %if.merge
  lw   t0, -60(s0)
  beqz t0, .entry_br_false_path_94500991829000
  j .float_abs_if.then
.entry_br_false_path_94500991829000:
  j .float_abs_if.merge
.float_abs_if.then:
  #   %x.val2 = load float, float* %x1
  addi t0, s0, -52
  flw  ft0, 0(t0)
  fsw  ft0, -64(s0)
  #   %fneg = fneg float %x.val2
  flw  ft0, -64(s0)
  fneg.s ft1, ft0
  fsw  ft1, -68(s0)
  #   ret float %fneg
  flw  fa0, -68(s0)
  j    .float_abs_epilogue
  #   br label %if.merge
  j .float_abs_if.merge
.float_abs_if.merge:
  #   %x.val3 = load float, float* %x1
  addi t0, s0, -52
  flw  ft0, 0(t0)
  fsw  ft0, -72(s0)
  #   ret float %x.val3
  flw  fa0, -72(s0)
  j    .float_abs_epilogue
.float_abs_epilogue:
  # Function Epilogue for float_abs
  lw   ra, 76(sp)
  lw   s0, 72(sp)
  addi sp, sp, 80
  ret

float_eq:
  # Function Prologue for float_eq
  addi sp, sp, -96
  sw   ra, 92(sp)
  sw   s0, 88(sp)
  addi s0, sp, 96
  fsw  fa0, -48(s0)
  fsw  fa1, -52(s0)
.float_eq_entry:
  #   %b2 = alloca float
  #   %a1 = alloca float
  #   store float %a, float* %a1
  addi t1, s0, -60
  flw  ft0, -48(s0)
  fsw  ft0, 0(t1)
  #   store float %b, float* %b2
  addi t1, s0, -56
  flw  ft0, -52(s0)
  fsw  ft0, 0(t1)
  #   %a.val = load float, float* %a1
  addi t0, s0, -60
  flw  ft0, 0(t0)
  fsw  ft0, -64(s0)
  #   %b.val = load float, float* %b2
  addi t0, s0, -56
  flw  ft0, 0(t0)
  fsw  ft0, -68(s0)
  #   %fsub_tmp = fsub float %a.val, %b.val
  flw  ft0, -64(s0)
  flw  ft1, -68(s0)
  fsub.s ft2, ft0, ft1
  fsw  ft2, -72(s0)
  #   %calltmp = call float @float_abs(float %fsub_tmp)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  flw  fa0, -72(s0)
  call float_abs
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  fsw  fa0, -76(s0)
  #   %EPS.val = load float, float* @EPS
  la   t0, EPS
  flw  ft0, 0(t0)
  fsw  ft0, -80(s0)
  #   %cmptmp = fcmp olt float %calltmp, %EPS.val
  flw  ft0, -76(s0)
  flw  ft1, -80(s0)
  flt.s t2, ft0, ft1
  sw   t2, -84(s0)
  #   br i1 %cmptmp, label %if.then, label %if.else
  lw   t0, -84(s0)
  beqz t0, .entry_br_false_path_94500991837608
  j .float_eq_if.then
.entry_br_false_path_94500991837608:
  j .float_eq_if.else
.float_eq_if.then:
  #   ret i32 1
  lui  a0, 0
  addi a0, a0, 1
  j    .float_eq_epilogue
  #   br label %if.merge
  j .float_eq_if.merge
.float_eq_if.else:
  #   ret i32 0
  lui  a0, 0
  j    .float_eq_epilogue
  #   br label %if.merge
  j .float_eq_if.merge
.float_eq_if.merge:
.float_eq_epilogue:
  # Function Epilogue for float_eq
  lw   ra, 92(sp)
  lw   s0, 88(sp)
  addi sp, sp, 96
  ret

error:
  # Function Prologue for error
  addi sp, sp, -48
  sw   ra, 44(sp)
  sw   s0, 40(sp)
  addi s0, sp, 48
.error_entry:
  #   call void @print_char(i8 101)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 101
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 114)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 114
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 114)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 114
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 111)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 111
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 114)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 114
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 10)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 10
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
.error_epilogue:
  # Function Epilogue for error
  lw   ra, 44(sp)
  lw   s0, 40(sp)
  addi sp, sp, 48
  ret

ok:
  # Function Prologue for ok
  addi sp, sp, -48
  sw   ra, 44(sp)
  sw   s0, 40(sp)
  addi s0, sp, 48
.ok_entry:
  #   call void @print_char(i8 111)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 111
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 107)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 107
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   call void @print_char(i8 10)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lui  a0, 0
  addi a0, a0, 10
  call print_char
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
.ok_epilogue:
  # Function Epilogue for ok
  lw   ra, 44(sp)
  lw   s0, 40(sp)
  addi sp, sp, 48
  ret

assert:
  # Function Prologue for assert
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
  sw   a0, -48(s0)
.assert_entry:
  #   %cond1 = alloca i32
  #   store i32 %cond, i32* %cond1
  addi t1, s0, -52
  lw   t0, -48(s0)
  sw   t0, 0(t1)
  #   %cond.val = load i32, i32* %cond1
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %eqtmp = icmp eq i32 %cond.val, 0
  lw   t0, -56(s0)
  lui  t1, 0
  li   t2, 0
  bne t0, t1, .assert_skip94500991845152
  li   t2, 1
.assert_skip94500991845152:
  sw   t2, -60(s0)
  #   br i1 %eqtmp, label %if.then, label %if.else
  lw   t0, -60(s0)
  beqz t0, .entry_br_false_path_94500991845640
  j .assert_if.then
.entry_br_false_path_94500991845640:
  j .assert_if.else
.assert_if.then:
  #   call void @error()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call error
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge
  j .assert_if.merge
.assert_if.else:
  #   call void @ok()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call ok
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge
  j .assert_if.merge
.assert_if.merge:
.assert_epilogue:
  # Function Epilogue for assert
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret

assert_not:
  # Function Prologue for assert_not
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
  sw   a0, -48(s0)
.assert_not_entry:
  #   %cond1 = alloca i32
  #   store i32 %cond, i32* %cond1
  addi t1, s0, -52
  lw   t0, -48(s0)
  sw   t0, 0(t1)
  #   %cond.val = load i32, i32* %cond1
  addi t0, s0, -52
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   %tobool = icmp ne i32 %cond.val, 0
  lw   t0, -56(s0)
  lui  t1, 0
  li   t2, 0
  beq t0, t1, .assert_not_skip94500991847568
  li   t2, 1
.assert_not_skip94500991847568:
  sw   t2, -60(s0)
  #   br i1 %tobool, label %if.then, label %if.else
  lw   t0, -60(s0)
  beqz t0, .entry_br_false_path_94500991848056
  j .assert_not_if.then
.entry_br_false_path_94500991848056:
  j .assert_not_if.else
.assert_not_if.then:
  #   call void @error()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call error
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge
  j .assert_not_if.merge
.assert_not_if.else:
  #   call void @ok()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call ok
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   br label %if.merge
  j .assert_not_if.merge
.assert_not_if.merge:
.assert_not_epilogue:
  # Function Epilogue for assert_not
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret

main:
  # Function Prologue for main
  addi sp, sp, -192
  sw   ra, 188(sp)
  sw   s0, 184(sp)
  addi s0, sp, 192
.main_entry:
  #   %EVAL1 = alloca float
  #   store float 0.000000e+00, float* %EVAL1
  addi t1, s0, -48
  lui  t3, 0
  addi t3, t3, 0
  sw   t3, -32(s0)
  flw  ft0, -32(s0)
  fsw  ft0, 0(t1)
  #   %PI.val = load float, float* @PI
  la   t0, PI
  flw  ft0, 0(t0)
  fsw  ft0, -52(s0)
  #   %RADIUS.val = load float, float* @RADIUS
  la   t0, RADIUS
  flw  ft0, 0(t0)
  fsw  ft0, -56(s0)
  #   %fmul_tmp = fmul float %PI.val, %RADIUS.val
  flw  ft0, -52(s0)
  flw  ft1, -56(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -60(s0)
  #   %RADIUS.val1 = load float, float* @RADIUS
  la   t0, RADIUS
  flw  ft0, 0(t0)
  fsw  ft0, -64(s0)
  #   %fmul_tmp2 = fmul float %fmul_tmp, %RADIUS.val1
  flw  ft0, -60(s0)
  flw  ft1, -64(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -68(s0)
  #   store float %fmul_tmp2, float* %EVAL1
  addi t1, s0, -48
  flw  ft0, -68(s0)
  fsw  ft0, 0(t1)
  #   %EVAL2 = alloca float
  #   store float 2.000000e+00, float* %EVAL2
  addi t1, s0, -72
  lui  t3, 262144
  addi t3, t3, 0
  sw   t3, -32(s0)
  flw  ft0, -32(s0)
  fsw  ft0, 0(t1)
  #   %EVAL2.val = load float, float* %EVAL2
  addi t0, s0, -72
  flw  ft0, 0(t0)
  fsw  ft0, -76(s0)
  #   %PI_HEX.val = load float, float* @PI_HEX
  la   t0, PI_HEX
  flw  ft0, 0(t0)
  fsw  ft0, -80(s0)
  #   %fmul_tmp3 = fmul float %EVAL2.val, %PI_HEX.val
  flw  ft0, -76(s0)
  flw  ft1, -80(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -84(s0)
  #   %RADIUS.val4 = load float, float* @RADIUS
  la   t0, RADIUS
  flw  ft0, 0(t0)
  fsw  ft0, -88(s0)
  #   %fmul_tmp5 = fmul float %fmul_tmp3, %RADIUS.val4
  flw  ft0, -84(s0)
  flw  ft1, -88(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -92(s0)
  #   store float %fmul_tmp5, float* %EVAL2
  addi t1, s0, -72
  flw  ft0, -92(s0)
  fsw  ft0, 0(t1)
  #   %EVAL3 = alloca float
  #   store float 2.000000e+00, float* %EVAL3
  addi t1, s0, -96
  lui  t3, 262144
  addi t3, t3, 0
  sw   t3, -32(s0)
  flw  ft0, -32(s0)
  fsw  ft0, 0(t1)
  #   %PI.val6 = load float, float* @PI
  la   t0, PI
  flw  ft0, 0(t0)
  fsw  ft0, -100(s0)
  #   %EVAL3.val = load float, float* %EVAL3
  addi t0, s0, -96
  flw  ft0, 0(t0)
  fsw  ft0, -104(s0)
  #   %fmul_tmp7 = fmul float %PI.val6, %EVAL3.val
  flw  ft0, -100(s0)
  flw  ft1, -104(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -108(s0)
  #   %RADIUS.val8 = load float, float* @RADIUS
  la   t0, RADIUS
  flw  ft0, 0(t0)
  fsw  ft0, -112(s0)
  #   %fmul_tmp9 = fmul float %fmul_tmp7, %RADIUS.val8
  flw  ft0, -108(s0)
  flw  ft1, -112(s0)
  fmul.s ft2, ft0, ft1
  fsw  ft2, -116(s0)
  #   store float %fmul_tmp9, float* %EVAL3
  addi t1, s0, -96
  flw  ft0, -116(s0)
  fsw  ft0, 0(t1)
  #   %FIVE = alloca i32
  #   store i32 0, i32* %FIVE
  addi t1, s0, -120
  lui  t0, 0
  sw   t0, 0(t1)
  #   %TWO.val = load i32, i32* @TWO
  la   t0, TWO
  lw   t1, 0(t0)
  sw   t1, -124(s0)
  #   %THREE.val = load i32, i32* @THREE
  la   t0, THREE
  lw   t1, 0(t0)
  sw   t1, -128(s0)
  #   %add_tmp = add i32 %TWO.val, %THREE.val
  lw   t0, -124(s0)
  lw   t1, -128(s0)
  add t2, t0, t1
  sw   t2, -132(s0)
  #   store i32 %add_tmp, i32* %FIVE
  addi t1, s0, -120
  lw   t0, -132(s0)
  sw   t0, 0(t1)
  #   %HEX2.val = load float, float* @HEX2
  la   t0, HEX2
  flw  ft0, 0(t0)
  fsw  ft0, -136(s0)
  #   %FACT.val = load float, float* @FACT
  la   t0, FACT
  flw  ft0, 0(t0)
  fsw  ft0, -140(s0)
  #   %calltmp = call i32 @float_eq(float %HEX2.val, float %FACT.val)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  flw  fa0, -136(s0)
  flw  fa1, -140(s0)
  call float_eq
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -144(s0)
  #   call void @assert_not(i32 %calltmp)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -144(s0)
  call assert_not
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %EVAL1.val = load float, float* %EVAL1
  addi t0, s0, -48
  flw  ft0, 0(t0)
  fsw  ft0, -148(s0)
  #   %EVAL2.val10 = load float, float* %EVAL2
  addi t0, s0, -72
  flw  ft0, 0(t0)
  fsw  ft0, -152(s0)
  #   %calltmp11 = call i32 @float_eq(float %EVAL1.val, float %EVAL2.val10)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  flw  fa0, -148(s0)
  flw  fa1, -152(s0)
  call float_eq
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -156(s0)
  #   call void @assert_not(i32 %calltmp11)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -156(s0)
  call assert_not
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %EVAL2.val12 = load float, float* %EVAL2
  addi t0, s0, -72
  flw  ft0, 0(t0)
  fsw  ft0, -160(s0)
  #   %EVAL3.val13 = load float, float* %EVAL3
  addi t0, s0, -96
  flw  ft0, 0(t0)
  fsw  ft0, -164(s0)
  #   %calltmp14 = call i32 @float_eq(float %EVAL2.val12, float %EVAL3.val13)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  flw  fa0, -160(s0)
  flw  fa1, -164(s0)
  call float_eq
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -168(s0)
  #   call void @assert(i32 %calltmp14)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -168(s0)
  call assert
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   %CONV1.val = load float, float* @CONV1
  la   t0, CONV1
  flw  ft0, 0(t0)
  fsw  ft0, -172(s0)
  #   %CONV2.val = load float, float* @CONV2
  la   t0, CONV2
  flw  ft0, 0(t0)
  fsw  ft0, -176(s0)
  #   %calltmp15 = call i32 @float_eq(float %CONV1.val, float %CONV2.val)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  flw  fa0, -172(s0)
  flw  fa1, -176(s0)
  call float_eq
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -180(s0)
  #   call void @assert_not(i32 %calltmp15)
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  lw   a0, -180(s0)
  call assert_not
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  #   ret i32 0
  lui  a0, 0
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 188(sp)
  lw   s0, 184(sp)
  addi sp, sp, 192
  ret
