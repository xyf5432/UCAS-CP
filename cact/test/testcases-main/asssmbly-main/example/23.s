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
  la t0, a
  lw t0, 0(t0)
  sw t0, 8(sp)
  la t0, b
  lw t0, 0(t0)
  lw t1, 8(sp)
  mul t0, t1, t0
  sw t0, 8(sp)
  la t0, c
  lw t0, 0(t0)
  lw t1, 8(sp)
  div t0, t1, t0
  sw t0, 8(sp)
  la t0, e
  lw t0, 0(t0)
  sw t0, 12(sp)
  la t0, d
  lw t0, 0(t0)
  lw t1, 12(sp)
  add t0, t1, t0
  lw t1, 8(sp)
  beq t1, t0, .bb_2
  j .bb_3
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 24
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
  la t0, a
  lw t0, 0(t0)
  sw t0, 12(sp)
  la t0, b
  lw t0, 0(t0)
  lw t1, 12(sp)
  add t0, t1, t0
  lw t1, 8(sp)
  mul t0, t1, t0
  sw t0, 8(sp)
  la t0, c
  lw t0, 0(t0)
  lw t1, 8(sp)
  add t0, t1, t0
  sw t0, 8(sp)
  la t0, d
  lw t0, 0(t0)
  sw t0, 12(sp)
  la t0, e
  lw t0, 0(t0)
  lw t1, 12(sp)
  add t0, t1, t0
  lw t1, 8(sp)
  blt t0, t1, .bb_10
  j .bb_9
.bb_6:
  ori t0, zero, 1
  j .bb_8
.bb_7:
  mv t0, zero
  j .bb_8
.bb_8:
  beq t0, zero, .bb_12
  j .bb_13
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
  la t0, a
  lw t0, 0(t0)
  sw t0, 8(sp)
  la t0, b
  lw t0, 0(t0)
  sw t0, 12(sp)
  la t0, c
  lw t0, 0(t0)
  lw t1, 12(sp)
  mul t0, t1, t0
  lw t1, 8(sp)
  sub t0, t1, t0
  sw t0, 8(sp)
  la t0, d
  lw t0, 0(t0)
  sw t0, 12(sp)
  la t0, a
  lw t0, 0(t0)
  sw t0, 16(sp)
  la t0, c
  lw t0, 0(t0)
  lw t1, 16(sp)
  div t0, t1, t0
  lw t1, 12(sp)
  sub t0, t1, t0
  lw t1, 8(sp)
  beq t1, t0, .bb_16
  j .bb_17
.bb_13:
  ori t0, zero, 1
  j .bb_15
.bb_14:
  mv t0, zero
  j .bb_15
.bb_15:
  bne t0, zero, .bb_19
  j .bb_20
.bb_16:
  li t0, 1
  j .bb_18
.bb_17:
  li t0, 0
  j .bb_18
.bb_18:
  beq t0, zero, .bb_14
  j .bb_13
.bb_19:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_20
.bb_20:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1


  .data
  .type a, @object
  .size a, 4
a:
  .word 1
  .type b, @object
  .size b, 4
b:
  .word 0
  .type c, @object
  .size c, 4
c:
  .word 1
  .type d, @object
  .size d, 4
d:
  .word 2
  .type e, @object
  .size e, 4
e:
  .word 4

