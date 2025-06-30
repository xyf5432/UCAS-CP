  .text
  .globl ifElseIf
  .type ifElseIf, @function
ifElseIf:
.bb_0:
  mv t1, sp
  addi sp, sp, -24
  sw ra, 0(sp)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 5
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 8
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 10
  lw t1, 12(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 6
  lw t1, 12(sp)
  beq t1, t0, .bb_2
  j .bb_3
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 24
  ret
.bb_2:
  li t0, 1
  j .bb_4
.bb_3:
  li t0, 0
  j .bb_4
.bb_4:
  beq t0, zero, .bb_5
  j .bb_6
.bb_5:
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 11
  lw t1, 12(sp)
  beq t1, t0, .bb_9
  j .bb_10
.bb_6:
  ori t0, zero, 1
  j .bb_8
.bb_7:
  mv t0, zero
  j .bb_8
.bb_8:
  bne t0, zero, .bb_12
  j .bb_14
.bb_9:
  li t0, 1
  j .bb_11
.bb_10:
  li t0, 0
  j .bb_11
.bb_11:
  beq t0, zero, .bb_7
  j .bb_6
.bb_12:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_13
.bb_13:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_14:
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 10
  lw t1, 12(sp)
  beq t1, t0, .bb_15
  j .bb_16
.bb_15:
  li t0, 1
  j .bb_17
.bb_16:
  li t0, 0
  j .bb_17
.bb_17:
  bne t0, zero, .bb_18
  j .bb_20
.bb_18:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 1
  lw t1, 12(sp)
  beq t1, t0, .bb_22
  j .bb_23
.bb_19:
  ori t0, zero, 1
  j .bb_21
.bb_20:
  mv t0, zero
  j .bb_21
.bb_21:
  bne t0, zero, .bb_25
  j .bb_27
.bb_22:
  li t0, 1
  j .bb_24
.bb_23:
  li t0, 0
  j .bb_24
.bb_24:
  bne t0, zero, .bb_19
  j .bb_20
.bb_25:
  li t0, 4
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 25
  lw t1, 12(sp)
  sw t0, 0(t1)
  j .bb_26
.bb_26:
  j .bb_13
.bb_27:
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 10
  lw t1, 12(sp)
  beq t1, t0, .bb_28
  j .bb_29
.bb_28:
  li t0, 1
  j .bb_30
.bb_29:
  li t0, 0
  j .bb_30
.bb_30:
  bne t0, zero, .bb_31
  j .bb_33
.bb_31:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, -5
  lw t1, 12(sp)
  beq t1, t0, .bb_35
  j .bb_36
.bb_32:
  ori t0, zero, 1
  j .bb_34
.bb_33:
  mv t0, zero
  j .bb_34
.bb_34:
  bne t0, zero, .bb_38
  j .bb_40
.bb_35:
  li t0, 1
  j .bb_37
.bb_36:
  li t0, 0
  j .bb_37
.bb_37:
  bne t0, zero, .bb_32
  j .bb_33
.bb_38:
  li t0, 4
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 16(sp)
  li t0, 15
  lw t1, 16(sp)
  add t0, t1, t0
  lw t1, 12(sp)
  sw t0, 0(t1)
  j .bb_39
.bb_39:
  j .bb_26
.bb_40:
  li t0, 4
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sub t0, zero, t0
  lw t1, 12(sp)
  sw t0, 0(t1)
  j .bb_39
  .globl main
  .type main, @function
main:
.bb_41:
  mv t1, sp
  addi sp, sp, -8
  sw ra, 0(sp)
  mv t1, sp
  addi sp, sp, 0
  jal ifElseIf
  addi sp, sp, 0
  mv t0, a0
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 4(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  li t0, 0
  mv a0, t0
  j .bb_42
  j .bb_42
.bb_42:
  lw ra, 0(sp)
  addi sp, sp, 8
  ret


  .data

