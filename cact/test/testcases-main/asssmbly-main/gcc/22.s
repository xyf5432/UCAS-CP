	.file	"22.cact"
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
	lui	a4,%hi(.LANCHOR0)
	addi	a4,a4,%lo(.LANCHOR0)
	lw	a3,4(a4)
	lw	a5,0(a4)
	lw	a1,8(a4)
	lw	a2,12(a4)
	add	a5,a5,a3
	lw	a3,16(a4)
	lw	a0,20(a4)
	add	a5,a5,a1
	add	a5,a5,a2
	add	a5,a5,a3
	add	a0,a5,a0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.globl	arr
	.data
	.align	2
	.set	.LANCHOR0,. + 0
	.type	arr, @object
	.size	arr, 24
arr:
	.word	1
	.word	2
	.word	33
	.word	4
	.word	5
	.word	6
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
