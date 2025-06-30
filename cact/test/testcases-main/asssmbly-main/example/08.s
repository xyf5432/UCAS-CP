  .text
  .globl func
  .type func, @function
func:
.bb_0:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  sw a0, 4(sp)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 1
  lw t1, 12(sp)
  sub t0, t1, t0
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret
  .globl main
  .type main, @function
main:
.bb_2:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  la t0, a
  sw t0, 8(sp)
  li t0, 10
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  la t0, a
  lw t0, 0(t0)
  sw t0, 12(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 12(t1)
  jal func
  addi sp, sp, 0
  mv t0, a0
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  mv a0, t0
  j .bb_3
  j .bb_3
.bb_3:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret


  .data
  .type a, @object
  .size a, 4
a:
  .word 0

