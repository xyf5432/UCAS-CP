  .text
  .globl func
  .type func, @function
func:
.bb_0:
  mv t1, sp
  addi sp, sp, -16
  sw ra, 0(sp)
  sw a0, 4(sp)
  la t0, g
  sw t0, 8(sp)
  la t0, g
  lw t0, 0(t0)
  sw t0, 12(sp)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  lw t1, 12(sp)
  add t0, t1, t0
  lw t1, 8(sp)
  sw t0, 0(t1)
  la t0, g
  lw t0, 0(t0)
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal print_int
  addi sp, sp, 0
  mv t0, zero
  la t0, g
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
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  jal get_int
  addi sp, sp, 0
  mv t0, a0
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 10
  lw t1, 8(sp)
  blt t0, t1, .bb_4
  j .bb_5
.bb_3:
  lw ra, 0(sp)
  addi sp, sp, 16
  ret
.bb_4:
  li t0, 1
  j .bb_6
.bb_5:
  li t0, 0
  j .bb_6
.bb_6:
  bne t0, zero, .bb_7
  j .bb_9
.bb_7:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal func
  addi sp, sp, 0
  mv t0, a0
  bne t0, zero, .bb_8
  j .bb_9
.bb_8:
  ori t0, zero, 1
  j .bb_10
.bb_9:
  mv t0, zero
  j .bb_10
.bb_10:
  bne t0, zero, .bb_11
  j .bb_13
.bb_11:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_12
.bb_12:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  jal get_int
  addi sp, sp, 0
  mv t0, a0
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 11
  lw t1, 8(sp)
  blt t0, t1, .bb_14
  j .bb_15
.bb_13:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_12
.bb_14:
  li t0, 1
  j .bb_16
.bb_15:
  li t0, 0
  j .bb_16
.bb_16:
  bne t0, zero, .bb_17
  j .bb_19
.bb_17:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal func
  addi sp, sp, 0
  mv t0, a0
  bne t0, zero, .bb_18
  j .bb_19
.bb_18:
  ori t0, zero, 1
  j .bb_20
.bb_19:
  mv t0, zero
  j .bb_20
.bb_20:
  bne t0, zero, .bb_21
  j .bb_23
.bb_21:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_22
.bb_22:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  jal get_int
  addi sp, sp, 0
  mv t0, a0
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 99
  lw t1, 8(sp)
  blt t0, t1, .bb_25
  j .bb_24
.bb_23:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_22
.bb_24:
  li t0, 1
  j .bb_26
.bb_25:
  li t0, 0
  j .bb_26
.bb_26:
  beq t0, zero, .bb_27
  j .bb_28
.bb_27:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal func
  addi sp, sp, 0
  mv t0, a0
  beq t0, zero, .bb_29
  j .bb_28
.bb_28:
  ori t0, zero, 1
  j .bb_30
.bb_29:
  mv t0, zero
  j .bb_30
.bb_30:
  bne t0, zero, .bb_31
  j .bb_33
.bb_31:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_32
.bb_32:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  jal get_int
  addi sp, sp, 0
  mv t0, a0
  lw t1, 8(sp)
  sw t0, 0(t1)
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  li t0, 100
  lw t1, 8(sp)
  blt t0, t1, .bb_35
  j .bb_34
.bb_33:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_32
.bb_34:
  li t0, 1
  j .bb_36
.bb_35:
  li t0, 0
  j .bb_36
.bb_36:
  beq t0, zero, .bb_37
  j .bb_38
.bb_37:
  li t0, 4
  add t0, t0, sp
  lw t0, 0(t0)
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal func
  addi sp, sp, 0
  mv t0, a0
  beq t0, zero, .bb_39
  j .bb_38
.bb_38:
  ori t0, zero, 1
  j .bb_40
.bb_39:
  mv t0, zero
  j .bb_40
.bb_40:
  bne t0, zero, .bb_41
  j .bb_43
.bb_41:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_42
.bb_42:
  li t0, 99
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal func
  addi sp, sp, 0
  slt t1, a0, zero
  slt t2, zero, a0
  and a0, t1, t2
  mv t0, a0
  bne t0, zero, .bb_44
  j .bb_46
.bb_43:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_42
.bb_44:
  li t0, 100
  sw t0, 8(sp)
  mv t1, sp
  addi sp, sp, 0
  lw a0, 8(t1)
  jal func
  addi sp, sp, 0
  mv t0, a0
  bne t0, zero, .bb_45
  j .bb_46
.bb_45:
  ori t0, zero, 1
  j .bb_47
.bb_46:
  mv t0, zero
  j .bb_47
.bb_47:
  bne t0, zero, .bb_48
  j .bb_50
.bb_48:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 1
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_49
.bb_49:
  li t0, 0
  mv a0, t0
  j .bb_3
  j .bb_3
.bb_50:
  li t0, 4
  add t0, t0, sp
  sw t0, 8(sp)
  li t0, 0
  lw t1, 8(sp)
  sw t0, 0(t1)
  j .bb_49


  .data
  .type g, @object
  .size g, 4
g:
  .word 0

