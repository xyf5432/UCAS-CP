  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 10
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 2
  lw t1, 8(sp)
  sub t0, t1, t0
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret


  .data

