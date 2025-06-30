  .text
  .globl inc_a
  .type inc_a, @function
inc_a:
.bb_0:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  li t0, 0
  li t1, 4
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  la t0, a
  lw t0, 0(t0)
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 1
  lw t1, 12(sp)
  add t0, t1, t0
  lw t1, 8(sp)
  sw t0, 0(t1)
  la t0, a
  sw t0, 8(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 8(sp)
  sw t0, 0(t1)
  la t0, a
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret
  .globl main
  .type main, @function
main:
.bb_2:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  li t0, 5
  li t1, 4
  add t1, t1, sp
  sw t0, 0(t1)
  j .bb_4
.bb_3:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret
.bb_4:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  bge t1, t0, .bb_5
  j .bb_6
.bb_5:
  li t0, 1
  j .bb_7
.bb_6:
  li t0, 0
  j .bb_7
.bb_7:
  bne t0, zero, .bb_8
  j .bb_9
.bb_8:
  mv t1, sp
  addi sp, sp, 0
  jal inc_a
  addi sp, sp, 0
  mv t0, a0
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  bne t1, t0, .bb_10
  j .bb_11
.bb_9:
  la t0, a
  lw t0, 0(t0)
  sw t0, 8(sp)
  la t0, b
  lw t0, 0(t0)
  lw t1, 8(sp)
  add t0, t1, t0
  mv a0, t0
  j .bb_3
  j .bb_3
.bb_10:
  li t0, 1
  j .bb_12
.bb_11:
  li t0, 0
  j .bb_12
.bb_12:
  bne t0, zero, .bb_13
  j .bb_15
.bb_13:
  mv t1, sp
  addi sp, sp, 0
  jal inc_a
  addi sp, sp, 0
  mv t0, a0
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  bne t1, t0, .bb_17
  j .bb_18
.bb_14:
  ori t0, zero, 1
  j .bb_16
.bb_15:
  mv t0, zero
  j .bb_16
.bb_16:
  bne t0, zero, .bb_20
  j .bb_22
.bb_17:
  li t0, 1
  j .bb_19
.bb_18:
  li t0, 0
  j .bb_19
.bb_19:
  bne t0, zero, .bb_14
  j .bb_15
.bb_20:
  mv t1, sp
  addi sp, sp, 0
  jal inc_a
  addi sp, sp, 0
  mv t0, a0
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  bne t1, t0, .bb_24
  j .bb_25
.bb_21:
  ori t0, zero, 1
  j .bb_23
.bb_22:
  mv t0, zero
  j .bb_23
.bb_23:
  bne t0, zero, .bb_27
  j .bb_28
.bb_24:
  li t0, 1
  j .bb_26
.bb_25:
  li t0, 0
  j .bb_26
.bb_26:
  bne t0, zero, .bb_21
  j .bb_22
.bb_27:
  la t0, a
  sw t0, 8(sp)
  la t0, a
  lw t0, 0(t0)
  sw t0, 12(sp)
  la t0, b
  lw t0, 0(t0)
  lw t1, 12(sp)
  add t0, t1, t0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_28
.bb_28:
  mv t1, sp
  addi sp, sp, 0
  jal inc_a
  addi sp, sp, 0
  mv t0, a0
  sw t0, 8(sp)
  li t0, 14
  lw t1, 8(sp)
  bge t1, t0, .bb_30
  j .bb_29
.bb_29:
  li t0, 1
  j .bb_31
.bb_30:
  li t0, 0
  j .bb_31
.bb_31:
  beq t0, zero, .bb_32
  j .bb_33
.bb_32:
  mv t1, sp
  addi sp, sp, 0
  jal inc_a
  addi sp, sp, 0
  mv t0, a0
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  bne t1, t0, .bb_36
  j .bb_37
.bb_33:
  ori t0, zero, 1
  j .bb_35
.bb_34:
  mv t0, zero
  j .bb_35
.bb_35:
  bne t0, zero, .bb_46
  j .bb_48
.bb_36:
  li t0, 1
  j .bb_38
.bb_37:
  li t0, 0
  j .bb_38
.bb_38:
  bne t0, zero, .bb_39
  j .bb_41
.bb_39:
  mv t1, sp
  addi sp, sp, 0
  jal inc_a
  addi sp, sp, 0
  mv t0, a0
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  jal inc_a
  addi sp, sp, 0
  mv t0, a0
  lw t1, 8(sp)
  sub t0, t1, t0
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  add t0, t1, t0
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  bne t1, t0, .bb_43
  j .bb_44
.bb_40:
  ori t0, zero, 1
  j .bb_42
.bb_41:
  mv t0, zero
  j .bb_42
.bb_42:
  beq t0, zero, .bb_34
  j .bb_33
.bb_43:
  li t0, 1
  j .bb_45
.bb_44:
  li t0, 0
  j .bb_45
.bb_45:
  bne t0, zero, .bb_40
  j .bb_41
.bb_46:
  la t0, a
  sw t0, 8(sp)
  la t0, b
  lw t0, 0(t0)
  lw t1, 8(sp)
  sw t0, 0(t1)
  la t0, b
  sw t0, 8(sp)
  la t0, b
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 2
  lw t1, 12(sp)
  mul t0, t1, t0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_47
.bb_47:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 1
  lw t1, 12(sp)
  sub t0, t1, t0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_4
.bb_48:
  mv t1, sp
  addi sp, sp, 0
  jal inc_a
  addi sp, sp, 0
  mv t0, a0
  j .bb_47


  .data
  .type a, @object
  .size a, 4
a:
  .word -1
  .type b, @object
  .size b, 4
b:
  .word 1

