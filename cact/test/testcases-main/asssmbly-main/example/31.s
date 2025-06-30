  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -32
  sw ra, 0(sp)
  la t0, k
  sw t0, 4(sp)
  li t0, 3389
  lw t1, 4(sp)
  sw t0, 0(t1)
  la t0, k
  lw t0, 0(t0)
  sw t0, 4(sp)
  li t0, 10000
  lw t1, 4(sp)
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
  bne t0, zero, .bb_5
  j .bb_6
.bb_5:
  la t0, k
  sw t0, 4(sp)
  la t0, k
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  add t0, t1, t0
  lw t1, 4(sp)
  sw t0, 0(t1)
  li t0, 112
  li t1, 4
  add t1, t1, sp
  sw t0, 0(t1)
  j .bb_7
.bb_6:
  la t0, k
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_7:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 10
  lw t1, 8(sp)
  blt t0, t1, .bb_8
  j .bb_9
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
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 88
  lw t1, 12(sp)
  sub t0, t1, t0
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 1000
  lw t1, 8(sp)
  bge t1, t0, .bb_14
  j .bb_13
.bb_12:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 20(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 20(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  j .bb_6
.bb_13:
  li t0, 1
  j .bb_15
.bb_14:
  li t0, 0
  j .bb_15
.bb_15:
  bne t0, zero, .bb_16
  j .bb_17
.bb_16:
  li t0, 9
  li t1, 8
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 11
  li t1, 12
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 8
  add t0, t0, sp
  sw t0, 16(sp)
  li t0, 10
  lw t1, 16(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 16(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 20(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 20(sp)
  sub t0, t1, t0
  lw t1, 16(sp)
  sw t0, 0(t1)
  li t0, 11
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
  add t0, t1, t0
  sw t0, 24(sp)
  li t0, 12
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 24(sp)
  add t0, t1, t0
  lw t1, 20(sp)
  sw t0, 0(t1)
  j .bb_17
.bb_17:
  j .bb_7


  .data
  .type k, @object
  .size k, 4
k:
  .word 0

