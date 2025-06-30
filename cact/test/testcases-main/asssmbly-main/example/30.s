  .text
  .globl func
  .type func, @function
func:
.bb_0:
  mv t1, sp
  addi sp, sp, -24
  sw ra, 0(sp)
  li t0, -1
  li t1, 4
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  la t0, a
  lw t0, 0(t0)
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 1
  li t1, 8
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 12(sp)
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
  li t0, 8
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 16(sp)
  li t0, 1
  lw t1, 16(sp)
  add t0, t1, t0
  lw t1, 12(sp)
  sw t0, 0(t1)
  li t0, 1
  mv a0, t0
  j .bb_1
  j .bb_6
.bb_6:
  j .bb_1
.bb_7:
  li t0, 0
  mv a0, t0
  j .bb_1
  j .bb_6
  .globl main
  .type main, @function
main:
.bb_8:
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
  j .bb_10
.bb_9:
  lw ra, 0(sp)
  addi sp, sp, 24
  ret
.bb_10:
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 100
  lw t1, 12(sp)
  bge t1, t0, .bb_12
  j .bb_11
.bb_11:
  li t0, 1
  j .bb_13
.bb_12:
  li t0, 0
  j .bb_13
.bb_13:
  bne t0, zero, .bb_14
  j .bb_15
.bb_14:
  mv t1, sp
  addi sp, sp, 0
  jal func
  addi sp, sp, 0
  mv t0, a0
  sw t0, 12(sp)
  li t0, 1
  lw t1, 12(sp)
  beq t1, t0, .bb_16
  j .bb_17
.bb_15:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 100
  lw t1, 12(sp)
  bge t1, t0, .bb_22
  j .bb_21
.bb_16:
  li t0, 1
  j .bb_18
.bb_17:
  li t0, 0
  j .bb_18
.bb_18:
  bne t0, zero, .bb_19
  j .bb_20
.bb_19:
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
  j .bb_20
.bb_20:
  li t0, 8
  add t0, t0, sp
  sw t0, 12(sp)
  li t0, 8
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 16(sp)
  li t0, 1
  lw t1, 16(sp)
  add t0, t1, t0
  lw t1, 12(sp)
  sw t0, 0(t1)
  j .bb_10
.bb_21:
  li t0, 1
  j .bb_23
.bb_22:
  li t0, 0
  j .bb_23
.bb_23:
  bne t0, zero, .bb_24
  j .bb_26
.bb_24:
  li t0, 1
  sw t0, 12(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 12(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  j .bb_25
.bb_25:
  li t0, 0
  mv a0, t0
  j .bb_9
  j .bb_9
.bb_26:
  li t0, 0
  sw t0, 12(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 12(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  j .bb_25


  .data
  .type a, @object
  .size a, 4
a:
  .word 7

