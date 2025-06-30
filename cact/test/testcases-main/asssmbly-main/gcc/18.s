	.file	"18.cact"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	ifElseIf
	.type	ifElseIf, @function
ifElseIf:
.LFB0:
	.cfi_startproc
	li	a0,-5
	ret
	.cfi_endproc
.LFE0:
	.size	ifElseIf, .-ifElseIf
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	li	a0,-5
	sw	ra,12(sp)
	.cfi_offset 1, -4
	call	print_int
	lw	ra,12(sp)
	.cfi_restore 1
	li	a0,0
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
