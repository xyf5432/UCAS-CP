  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -8
  sw ra, 0(sp)
  la t0, a
  sw t0, 4(sp)
  li t0, 4
  lw t1, 4(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 8
  ret


  .data
  .type a, @object
  .size a, 20
a:
  .word 0
  .word 1
  .word 2
  .word 3
  .word 4

