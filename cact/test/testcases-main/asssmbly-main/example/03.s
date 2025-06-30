  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -32
  sw ra, 0(sp)
  li t0, 8
  li t1, 8
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 12
  li t1, 12
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 16(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 20(sp)
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 20(sp)
  add t0, t1, t0
  lw t1, 16(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  li t0, 9
  li t1, 16
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 20(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 24(sp)
  li t0, 16
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 24(sp)
  mul t0, t1, t0
  lw t1, 20(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  li t1, 20
  add t1, t1, sp
  li t0, 4
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 24(sp)
  li t0, 20
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 28(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  sub t0, t1, t0
  sw t0, 28(sp)
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 28(sp)
  mul t0, t1, t0
  lw t1, 24(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 32
  ret


  .data

