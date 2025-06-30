	.file	"28.cact"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	func
	.type	func, @function
func:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	s0,8(sp)
	.cfi_offset 8, -8
	lui	s0,%hi(g)
	lw	a5,%lo(g)(s0)
	sw	ra,12(sp)
	.cfi_offset 1, -4
	add	a0,a0,a5
	sw	a0,%lo(g)(s0)
	call	print_int
	lw	a0,%lo(g)(s0)
	lw	ra,12(sp)
	.cfi_restore 1
	lw	s0,8(sp)
	.cfi_restore 8
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	func, .-func
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	s0,8(sp)
	sw	ra,12(sp)
	.cfi_offset 8, -8
	.cfi_offset 1, -4
	call	get_int
	li	a5,10
	lui	s0,%hi(g)
	bgt	a0,a5,.L12
.L5:
	call	get_int
	li	a5,11
	bgt	a0,a5,.L13
.L6:
	call	get_int
	li	a5,99
	bgt	a0,a5,.L14
.L7:
	call	get_int
	li	a5,100
	bgt	a0,a5,.L15
.L8:
	lw	a0,%lo(g)(s0)
	addi	a0,a0,99
	sw	a0,%lo(g)(s0)
	call	print_int
	lw	a5,%lo(g)(s0)
	beq	a5,zero,.L16
.L9:
	lw	ra,12(sp)
	.cfi_remember_state
	.cfi_restore 1
	lw	s0,8(sp)
	.cfi_restore 8
	li	a0,0
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
.L12:
	.cfi_restore_state
	lw	a5,%lo(g)(s0)
	add	a0,a0,a5
	sw	a0,%lo(g)(s0)
	call	print_int
	j	.L5
.L16:
	li	a0,100
	sw	a0,%lo(g)(s0)
	call	print_int
	j	.L9
.L15:
	lw	a5,%lo(g)(s0)
	add	a0,a0,a5
	sw	a0,%lo(g)(s0)
	call	print_int
	j	.L8
.L14:
	lw	a5,%lo(g)(s0)
	add	a0,a0,a5
	sw	a0,%lo(g)(s0)
	call	print_int
	j	.L7
.L13:
	lw	a5,%lo(g)(s0)
	add	a0,a0,a5
	sw	a0,%lo(g)(s0)
	call	print_int
	j	.L6
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.globl	g
	.section	.sbss,"aw",@nobits
	.align	2
	.type	g, @object
	.size	g, 4
g:
	.zero	4
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
