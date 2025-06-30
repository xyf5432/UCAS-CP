	.file	"30.cact"
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
	lui	a5,%hi(a)
	lw	a0,%lo(a)(a5)
	addi	a0,a0,-1
	seqz	a0,a0
	ret
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
	lui	a5,%hi(a)
	lw	a5,%lo(a)(a5)
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)
	.cfi_offset 1, -4
	li	a0,1
	beq	a5,a0,.L7
	call	print_int
.L5:
	lw	ra,12(sp)
	.cfi_remember_state
	.cfi_restore 1
	li	a0,0
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
.L7:
	.cfi_restore_state
	li	a0,0
	call	print_int
	j	.L5
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.globl	a
	.section	.sdata,"aw"
	.align	2
	.type	a, @object
	.size	a, 4
a:
	.word	7
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
