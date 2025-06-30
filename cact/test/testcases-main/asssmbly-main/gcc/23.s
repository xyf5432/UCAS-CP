	.file	"23.cact"
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
	lui	a5,%hi(a)
	lui	a4,%hi(b)
	lw	a5,%lo(a)(a5)
	lw	a4,%lo(b)(a4)
	lui	a3,%hi(c)
	lw	a1,%lo(c)(a3)
	mul	a2,a5,a4
	lui	a3,%hi(d)
	lui	a0,%hi(e)
	lw	a3,%lo(d)(a3)
	lw	a0,%lo(e)(a0)
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	ra,12(sp)
	sw	s0,8(sp)
	.cfi_offset 1, -4
	.cfi_offset 8, -8
	add	a0,a3,a0
	div	a2,a2,a1
	beq	a2,a0,.L7
.L2:
	div	a2,a5,a1
	mul	a4,a4,a1
	sub	a3,a3,a2
	sub	a5,a5,a4
	sub	a5,a5,a3
	seqz	s0,a5
.L3:
	mv	a0,s0
	call	print_int
	lw	ra,12(sp)
	.cfi_remember_state
	.cfi_restore 1
	mv	a0,s0
	lw	s0,8(sp)
	.cfi_restore 8
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
.L7:
	.cfi_restore_state
	add	a0,a5,a4
	mul	a0,a0,a5
	li	s0,1
	add	a0,a0,a1
	bge	a2,a0,.L3
	j	.L2
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	e
	.globl	d
	.globl	c
	.globl	b
	.globl	a
	.section	.sbss,"aw",@nobits
	.align	2
	.type	b, @object
	.size	b, 4
b:
	.zero	4
	.section	.sdata,"aw"
	.align	2
	.type	e, @object
	.size	e, 4
e:
	.word	4
	.type	d, @object
	.size	d, 4
d:
	.word	2
	.type	c, @object
	.size	c, 4
c:
	.word	1
	.type	a, @object
	.size	a, 4
a:
	.word	1
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
