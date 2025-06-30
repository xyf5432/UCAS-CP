	.file	"32.cact"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	float_abs
	.type	float_abs, @function
float_abs:
.LFB0:
	.cfi_startproc
	fmv.s.x	fa5,zero
	flt.s	a5,fa0,fa5
	bne	a5,zero,.L6
	ret
.L6:
	fneg.s	fa0,fa0
	ret
	.cfi_endproc
.LFE0:
	.size	float_abs, .-float_abs
	.align	1
	.globl	float_eq
	.type	float_eq, @function
float_eq:
.LFB1:
	.cfi_startproc
	fsub.s	fa0,fa0,fa1
	fmv.s.x	fa5,zero
	flt.s	a5,fa0,fa5
	bne	a5,zero,.L11
	lui	a5,%hi(.LC0)
	flw	fa5,%lo(.LC0)(a5)
	flt.s	a0,fa0,fa5
	ret
.L11:
	lui	a5,%hi(.LC0)
	fneg.s	fa0,fa0
	flw	fa5,%lo(.LC0)(a5)
	flt.s	a0,fa0,fa5
	ret
	.cfi_endproc
.LFE1:
	.size	float_eq, .-float_eq
	.align	1
	.globl	error
	.type	error, @function
error:
.LFB2:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	li	a0,101
	sw	ra,12(sp)
	.cfi_offset 1, -4
	call	print_char
	li	a0,114
	call	print_char
	li	a0,114
	call	print_char
	li	a0,111
	call	print_char
	li	a0,114
	call	print_char
	lw	ra,12(sp)
	.cfi_restore 1
	li	a0,10
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	tail	print_char
	.cfi_endproc
.LFE2:
	.size	error, .-error
	.align	1
	.globl	ok
	.type	ok, @function
ok:
.LFB3:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	li	a0,111
	sw	ra,12(sp)
	.cfi_offset 1, -4
	call	print_char
	li	a0,107
	call	print_char
	lw	ra,12(sp)
	.cfi_restore 1
	li	a0,10
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	tail	print_char
	.cfi_endproc
.LFE3:
	.size	ok, .-ok
	.align	1
	.globl	assert
	.type	assert, @function
assert:
.LFB4:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)
	.cfi_offset 1, -4
	bne	a0,zero,.L17
	li	a0,101
	call	print_char
	li	a0,114
	call	print_char
	li	a0,114
	call	print_char
	li	a0,111
	call	print_char
	li	a0,114
	call	print_char
	lw	ra,12(sp)
	.cfi_remember_state
	.cfi_restore 1
	li	a0,10
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	tail	print_char
.L17:
	.cfi_restore_state
	li	a0,111
	call	print_char
	li	a0,107
	call	print_char
	lw	ra,12(sp)
	.cfi_restore 1
	li	a0,10
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	tail	print_char
	.cfi_endproc
.LFE4:
	.size	assert, .-assert
	.align	1
	.globl	assert_not
	.type	assert_not, @function
assert_not:
.LFB5:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)
	.cfi_offset 1, -4
	beq	a0,zero,.L21
	li	a0,101
	call	print_char
	li	a0,114
	call	print_char
	li	a0,114
	call	print_char
	li	a0,111
	call	print_char
	li	a0,114
	call	print_char
	lw	ra,12(sp)
	.cfi_remember_state
	.cfi_restore 1
	li	a0,10
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	tail	print_char
.L21:
	.cfi_restore_state
	li	a0,111
	call	print_char
	li	a0,107
	call	print_char
	lw	ra,12(sp)
	.cfi_restore 1
	li	a0,10
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	tail	print_char
	.cfi_endproc
.LFE5:
	.size	assert_not, .-assert_not
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)
	.cfi_offset 1, -4
	call	ok
	call	ok
	call	ok
	call	ok
	lw	ra,12(sp)
	.cfi_restore 1
	li	a0,0
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.globl	THREE
	.globl	TWO
	.globl	MAX
	.globl	CONV2
	.globl	CONV1
	.globl	FACT
	.globl	HEX2
	.globl	PI_HEX
	.globl	EPS
	.globl	PI
	.globl	RADIUS
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	897988541
	.section	.srodata,"a"
	.align	2
	.type	THREE, @object
	.size	THREE, 4
THREE:
	.word	3
	.type	TWO, @object
	.size	TWO, 4
TWO:
	.word	2
	.type	MAX, @object
	.size	MAX, 4
MAX:
	.word	1000000000
	.type	CONV2, @object
	.size	CONV2, 4
CONV2:
	.word	1166012416
	.type	CONV1, @object
	.size	CONV1, 4
CONV1:
	.word	1130954752
	.type	FACT, @object
	.size	FACT, 4
FACT:
	.word	-956241920
	.type	HEX2, @object
	.size	HEX2, 4
HEX2:
	.word	1033895936
	.type	PI_HEX, @object
	.size	PI_HEX, 4
PI_HEX:
	.word	1078530011
	.type	EPS, @object
	.size	EPS, 4
EPS:
	.word	897988541
	.type	PI, @object
	.size	PI, 4
PI:
	.word	1078530011
	.type	RADIUS, @object
	.size	RADIUS, 4
RADIUS:
	.word	1085276160
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
