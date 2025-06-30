  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  la t0, a
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  jal get_int
  addi sp, sp, 0
  mv t0, a0
  lw t1, 4(sp)
  sw t0, 0(t1)
  la t0, b
  sw t0, 4(sp)
  mv t1, sp
  addi sp, sp, 0
  jal get_int
  addi sp, sp, 0
  mv t0, a0
  lw t1, 4(sp)
  sw t0, 0(t1)
  la t0, a
  lw t0, 0(t0)
  sw t0, 8(sp)
  la t0, b
  lw t0, 0(t0)
  lw t1, 8(sp)
  beq t1, t0, .bb_2
  j .bb_3
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret
.bb_2:
  li t0, 1
  j .bb_4
.bb_3:
  li t0, 0
  j .bb_4
.bb_4:
  bne t0, zero, .bb_5
  j .bb_7
.bb_5:
  la t0, a
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 3
  lw t1, 8(sp)
  bne t1, t0, .bb_9
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
  bne t0, zero, .bb_6
  j .bb_7
.bb_12:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_13
.bb_13:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_14:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_13


  .data
  .type a, @object
  .size a, 4
a:
  .word 0
  .type b, @object
  .size b, 4
b:
  .word 0

