.data

.text
.globl main
.type main, @function

defn:
  # Function Prologue for defn
  addi sp, sp, -48
  sw   ra, 44(sp)
  sw   s0, 40(sp)
  addi s0, sp, 48
.defn_entry:
  #   ret i32 4
  lui  a0, 0
  addi a0, a0, 4
  j    .defn_epilogue
.defn_epilogue:
  # Function Epilogue for defn
  lw   ra, 44(sp)
  lw   s0, 40(sp)
  addi sp, sp, 48
  ret

main:
  # Function Prologue for main
  addi sp, sp, -64
  sw   ra, 60(sp)
  sw   s0, 56(sp)
  addi s0, sp, 64
.main_entry:
  #   %a = alloca i32
  #   store i32 0, i32* %a
  addi t1, s0, -48
  lui  t0, 0
  sw   t0, 0(t1)
  #   %calltmp = call i32 @defn()
  # --- Saving caller-saved registers before call ---
  sw   t0, -20(s0)
  sw   t1, -24(s0)
  sw   t2, -28(s0)
  sw   t3, -32(s0)
  sw   t4, -36(s0)
  sw   t5, -40(s0)
  sw   t6, -44(s0)
  call defn
  # --- Restoring caller-saved registers after call ---
  lw   t0, -20(s0)
  lw   t1, -24(s0)
  lw   t2, -28(s0)
  lw   t3, -32(s0)
  lw   t4, -36(s0)
  lw   t5, -40(s0)
  lw   t6, -44(s0)
  sw   a0, -52(s0)
  #   store i32 %calltmp, i32* %a
  addi t1, s0, -48
  lw   t0, -52(s0)
  sw   t0, 0(t1)
  #   %a.val = load i32, i32* %a
  addi t0, s0, -48
  lw   t1, 0(t0)
  sw   t1, -56(s0)
  #   ret i32 %a.val
  lw   a0, -56(s0)
  j    .main_epilogue
.main_epilogue:
  # Function Epilogue for main
  lw   ra, 60(sp)
  lw   s0, 56(sp)
  addi sp, sp, 64
  ret
