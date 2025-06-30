  .text
  .globl main
  .type main, @function
main:
.bb_0:
  mv t1, sp
  addi sp, sp, -112
  sw ra, 0(sp)
  li a0, 4
  add a0, a0, sp
  li a1, 0
  li a2, 32
  jal memset
  li t0, 1
  li t1, 36
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 2
  li t1, 40
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 3
  li t1, 44
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 4
  li t1, 48
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 5
  li t1, 52
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 6
  li t1, 56
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 7
  li t1, 60
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 8
  li t1, 64
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 1
  li t1, 68
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 2
  li t1, 72
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 3
  li t1, 76
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 4
  li t1, 80
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 5
  li t1, 84
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 6
  li t1, 88
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 7
  li t1, 92
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 8
  li t1, 96
  add t1, t1, sp
  sw t0, 0(t1)
  li t0, 68
  add t0, t0, sp
  sw t0, 100(sp)
  li t0, 0
  lw t1, 100(sp)
  li t2, 8
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 100(sp)
  li t0, 0
  lw t1, 100(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 100(sp)
  li t0, 36
  add t0, t0, sp
  sw t0, 104(sp)
  li t0, 2
  lw t1, 104(sp)
  li t2, 8
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 104(sp)
  li t0, 1
  lw t1, 104(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  lw t0, 0(t0)
  lw t1, 100(sp)
  sw t0, 0(t1)
  li t0, 68
  add t0, t0, sp
  sw t0, 100(sp)
  li t0, 0
  lw t1, 100(sp)
  li t2, 8
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 100(sp)
  li t0, 1
  lw t1, 100(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 100(sp)
  li t0, 36
  add t0, t0, sp
  sw t0, 104(sp)
  li t0, 1
  lw t1, 104(sp)
  li t2, 8
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 104(sp)
  li t0, 1
  lw t1, 104(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  lw t0, 0(t0)
  lw t1, 100(sp)
  sw t0, 0(t1)
  li t0, 68
  add t0, t0, sp
  sw t0, 100(sp)
  li t0, 3
  lw t1, 100(sp)
  li t2, 8
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 100(sp)
  li t0, 1
  lw t1, 100(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  lw t0, 0(t0)
  sw t0, 100(sp)
  li t0, 68
  add t0, t0, sp
  sw t0, 104(sp)
  li t0, 0
  lw t1, 104(sp)
  li t2, 8
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 104(sp)
  li t0, 0
  lw t1, 104(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  lw t0, 0(t0)
  lw t1, 100(sp)
  add t0, t1, t0
  sw t0, 100(sp)
  li t0, 68
  add t0, t0, sp
  sw t0, 104(sp)
  li t0, 0
  lw t1, 104(sp)
  li t2, 8
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 104(sp)
  li t0, 1
  lw t1, 104(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  lw t0, 0(t0)
  lw t1, 100(sp)
  add t0, t1, t0
  sw t0, 100(sp)
  li t0, 4
  add t0, t0, sp
  sw t0, 104(sp)
  li t0, 2
  lw t1, 104(sp)
  li t2, 8
  mul t0, t0, t2
  add t0, t0, t1
  sw t0, 104(sp)
  li t0, 0
  lw t1, 104(sp)
  li t2, 4
  mul t0, t0, t2
  add t0, t0, t1
  lw t0, 0(t0)
  lw t1, 100(sp)
  add t0, t1, t0
  mv a0, t0
  j .bb_1
  j .bb_1
.bb_1:
  lw ra, 0(sp)
  addi sp, sp, 112
  ret


  .data

