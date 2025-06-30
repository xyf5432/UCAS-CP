  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -24
  sw ra, 0(sp)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 8
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 0
  lw t1, 12(sp)
  sw t0, 0(t1)
  j .bb_2
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 24
  ret
.bb_2:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 100
  lw t1, 12(sp)
  bge t1, t0, .bb_4
  j .bb_3
.bb_3:
  li t0, 1
  j .bb_5
.bb_4:
  li t0, 0
  j .bb_5
.bb_5:
  bne t0, zero, .bb_6
  j .bb_7
.bb_6:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 50
  lw t1, 12(sp)
  beq t1, t0, .bb_8
  j .bb_9
.bb_7:
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 256
  lw t1, 12(sp)
  rem t0, t1, t0
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_8:
  li t0, 1
  j .bb_10
.bb_9:
  li t0, 0
  j .bb_10
.bb_10:
  bne t0, zero, .bb_11
  j .bb_12
.bb_11:
  j .bb_7
  j .bb_12
.bb_12:
  li t0, 8
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 16(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 16(sp)
  add t0, t1, t0
  lw t1, 12(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 16(sp)
  li t0, 1
  lw t1, 16(sp)
  add t0, t1, t0
  lw t1, 12(sp)
  sw t0, 0(t1)
  j .bb_2


  .data

