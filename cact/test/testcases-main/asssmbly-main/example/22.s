  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -24
  sw ra, 0(sp)
  li t0, 0
  li t1, 4
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 0
  li t1, 8
  add t1, t1, sp
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
  li t0, 6
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
  li t0, 8
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 16(sp)
  la t0, arr
  sw t0, 20(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 20(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
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
.bb_7:
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1


  .data
  .type arr, @object
  .size arr, 24
arr:
  .word 1
  .word 2
  .word 33
  .word 4
  .word 5
  .word 6

