  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -8
  sw ra, 0(sp)
  la t0, b
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
  .size a, 4
a:
  .word 10
  .type b, @object
  .size b, 4
b:
  .word 5

