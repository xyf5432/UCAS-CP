  .text
  .globl defn
  .type defn, @function
defn:
.bb_0:
  mv t1, sp
  addi sp, sp, -8
  sw ra, 0(sp)
  li t0, 4
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 8
  ret
  .globl main
  .type main, @function
main:
.bb_2:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  li t0, 0
  li t1, 4
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  jal defn
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

