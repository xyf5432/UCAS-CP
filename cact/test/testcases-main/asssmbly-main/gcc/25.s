	.file	"25.cact"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)
	sw	s0,8(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	call	get_int
	lui	s0,%hi(a)
	sw	a0,%lo(a)(s0)
	call	get_int
	lw	a4,%lo(a)(s0)
	lui	a3,%hi(b)
	mv	a5,a0
	sw	a0,%lo(b)(a3)
	li	a0,0
	bne	a5,a4,.L1
	addi	a5,a5,-3
	snez	a0,a5
.L1:
	lw	ra,12(sp)
	.cfi_restore 1
	lw	s0,8(sp)
	.cfi_restore 8
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	b
	.globl	a
	.section	.sbss,"aw",@nobits
	.align	2
	.type	b, @object
	.size	b, 4
b:
	.zero	4
	.type	a, @object
	.size	a, 4
a:
	.zero	4
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
