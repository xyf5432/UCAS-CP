	.file	"05.cact"
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
	li	a0,5
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	b
	.globl	a
	.section	.srodata,"a"
	.align	2
	.type	b, @object
	.size	b, 4
b:
	.word	5
	.type	a, @object
	.size	a, 4
a:
	.word	10
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
