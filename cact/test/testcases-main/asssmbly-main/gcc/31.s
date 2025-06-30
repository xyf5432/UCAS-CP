	.file	"31.cact"
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
	li	a5,4096
	sw	s0,8(sp)
	addi	a5,a5,-706
	.cfi_offset 8, -8
	lui	s0,%hi(k)
	li	a0,-40
	sw	ra,12(sp)
	.cfi_offset 1, -4
	sw	a5,%lo(k)(s0)
	call	print_int
	lw	a0,%lo(k)(s0)
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
	.globl	k
	.section	.sbss,"aw",@nobits
	.align	2
	.type	k, @object
	.size	k, 4
k:
	.zero	4
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
