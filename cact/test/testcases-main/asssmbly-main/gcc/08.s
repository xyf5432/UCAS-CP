	.file	"08.cact"
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
	addi	a0,a0,-1
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
	li	a4,10
	sw	a4,%lo(a)(a5)
	li	a0,9
	ret
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.globl	a
	.section	.sbss,"aw",@nobits
	.align	2
	.type	a, @object
	.size	a, 4
a:
	.zero	4
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
