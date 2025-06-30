  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -32
  sw ra, 0(sp)
  li t0, 4
  add t0, t0, sp
  sw t0, 24(sp)
  li t0, 5
  lw t1, 24(sp)
  sw t0, 0(t1)
  li t0, 8
  add t0, t0, sp
  sw t0, 24(sp)
  li t0, 5
  lw t1, 24(sp)
  sw t0, 0(t1)
  li t0, 12
  add t0, t0, sp
  sw t0, 24(sp)
  li t0, 1
  lw t1, 24(sp)
  sw t0, 0(t1)
  li t0, 16
  add t0, t0, sp
  sw t0, 24(sp)
  li t0, -2
  lw t1, 24(sp)
  sw t0, 0(t1)
  li t0, 20
  add t0, t0, sp
  sw t0, 24(sp)
  li t0, 2
  lw t1, 24(sp)
  sw t0, 0(t1)
  li t0, 16
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  li t0, 1
  lw t1, 24(sp)
  mul t0, t1, t0
  sw t0, 24(sp)
  li t0, 2
  lw t1, 24(sp)
  div t0, t1, t0
  sw t0, 24(sp)
  li t0, 0
  lw t1, 24(sp)
  bge t1, t0, .bb_3
  j .bb_2
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 32
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
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 24(sp)
  sub t0, t1, t0
  sw t0, 24(sp)
  li t0, 0
  lw t1, 24(sp)
  bne t1, t0, .bb_9
  j .bb_10
.bb_6:
  ori t0, zero, 1
  j .bb_8
.bb_7:
  mv t0, zero
  j .bb_8
.bb_8:
  bne t0, zero, .bb_19
  j .bb_20
.bb_9:
  li t0, 1
  j .bb_11
.bb_10:
  li t0, 0
  j .bb_11
.bb_11:
  bne t0, zero, .bb_12
  j .bb_14
.bb_12:
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  li t0, 3
  lw t1, 24(sp)
  add t0, t1, t0
  sw t0, 24(sp)
  li t0, 2
  lw t1, 24(sp)
  rem t0, t1, t0
  sw t0, 24(sp)
  li t0, 0
  lw t1, 24(sp)
  bne t1, t0, .bb_16
  j .bb_17
.bb_13:
  ori t0, zero, 1
  j .bb_15
.bb_14:
  mv t0, zero
  j .bb_15
.bb_15:
  beq t0, zero, .bb_7
  j .bb_6
.bb_16:
  li t0, 1
  j .bb_18
.bb_17:
  li t0, 0
  j .bb_18
.bb_18:
  bne t0, zero, .bb_13
  j .bb_14
.bb_19:
  li t0, 20
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 24(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  j .bb_20
.bb_20:
  li t0, 16
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  li t0, 2
  lw t1, 24(sp)
  rem t0, t1, t0
  sw t0, 24(sp)
  li t0, 67
  lw t1, 24(sp)
  add t0, t1, t0
  sw t0, 24(sp)
  li t0, 0
  lw t1, 24(sp)
  bge t1, t0, .bb_22
  j .bb_21
.bb_21:
  li t0, 1
  j .bb_23
.bb_22:
  li t0, 0
  j .bb_23
.bb_23:
  beq t0, zero, .bb_24
  j .bb_25
.bb_24:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 24(sp)
  sub t0, t1, t0
  sw t0, 24(sp)
  li t0, 0
  lw t1, 24(sp)
  bne t1, t0, .bb_28
  j .bb_29
.bb_25:
  ori t0, zero, 1
  j .bb_27
.bb_26:
  mv t0, zero
  j .bb_27
.bb_27:
  bne t0, zero, .bb_38
  j .bb_39
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
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  li t0, 2
  lw t1, 24(sp)
  add t0, t1, t0
  sw t0, 24(sp)
  li t0, 2
  lw t1, 24(sp)
  rem t0, t1, t0
  sw t0, 24(sp)
  li t0, 0
  lw t1, 24(sp)
  bne t1, t0, .bb_35
  j .bb_36
.bb_32:
  ori t0, zero, 1
  j .bb_34
.bb_33:
  mv t0, zero
  j .bb_34
.bb_34:
  beq t0, zero, .bb_26
  j .bb_25
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
  li t0, 20
  add t0, t0, sp
  sw t0, 24(sp)
  li t0, 4
  lw t1, 24(sp)
  sw t0, 0(t1)
  li t0, 20
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 24(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  j .bb_39
.bb_39:
  li t0, 0
  mv a0, t0
  j .bb_1
  j .bb_1


  .data

