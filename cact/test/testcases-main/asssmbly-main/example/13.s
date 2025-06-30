  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -8
  sw ra, 0(sp)
  la t0, a
  lw t0, 0(t0)
  sw t0, 4(sp)
  li t0, 5
  lw t1, 4(sp)
  mul t0, t1, t0
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 8
  ret


  .data
  .type a, @object
  .size a, 4
a:
  .word 5

