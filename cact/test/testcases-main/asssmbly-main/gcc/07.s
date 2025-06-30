	.file	"07.cact"
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
	li	a0,4
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	a
	.section	.rodata
	.align	2
	.type	a, @object
	.size	a, 20
a:
	.word	0
	.word	1
	.word	2
	.word	3
	.word	4
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
