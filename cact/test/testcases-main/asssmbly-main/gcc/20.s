	.file	"20.cact"
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
	li	a4,0
	li	a5,0
	li	a3,100
	li	a2,50
.L2:
	add	a4,a4,a5
	addi	a5,a5,1
	beq	a5,a3,.L6
.L4:
	bne	a5,a2,.L2
	li	a5,52
	addi	a4,a4,51
	add	a4,a4,a5
	addi	a5,a5,1
	bne	a5,a3,.L4
.L6:
	srai	a0,a4,31
	srli	a0,a0,24
	add	a5,a4,a0
	andi	a5,a5,255
	sub	a0,a5,a0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
