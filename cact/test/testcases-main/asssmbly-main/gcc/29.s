	.file	"29.cact"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	set_a
	.type	set_a, @function
set_a:
.LFB0:
	.cfi_startproc
	lui	a5,%hi(a)
	sw	a0,%lo(a)(a5)
	ret
	.cfi_endproc
.LFE0:
	.size	set_a, .-set_a
	.align	1
	.globl	set_b
	.type	set_b, @function
set_b:
.LFB1:
	.cfi_startproc
	lui	a5,%hi(b)
	sw	a0,%lo(b)(a5)
	ret
	.cfi_endproc
.LFE1:
	.size	set_b, .-set_b
	.align	1
	.globl	set_d
	.type	set_d, @function
set_d:
.LFB2:
	.cfi_startproc
	lui	a5,%hi(d)
	sw	a0,%lo(d)(a5)
	ret
	.cfi_endproc
.LFE2:
	.size	set_d, .-set_d
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	addi	sp,sp,-16
	.cfi_def_cfa_offset 16
	sw	s0,8(sp)
	sw	s1,4(sp)
	sw	s2,0(sp)
	.cfi_offset 8, -8
	.cfi_offset 9, -12
	.cfi_offset 18, -16
	lui	s1,%hi(b)
	li	s0,3
	lui	s2,%hi(a)
	li	a0,0
	sw	ra,12(sp)
	.cfi_offset 1, -4
	sw	s0,%lo(b)(s1)
	sw	zero,%lo(a)(s2)
	call	print_int
	li	a0,32
	call	print_char
	lw	a0,%lo(b)(s1)
	call	print_int
	li	a0,32
	call	print_char
	li	a0,0
	sw	s0,%lo(b)(s1)
	sw	zero,%lo(a)(s2)
	call	print_int
	li	a0,32
	call	print_char
	lw	a0,%lo(b)(s1)
	lui	s1,%hi(d)
	call	print_int
	li	a0,10
	call	print_char
	mv	a0,s0
	sw	s0,%lo(d)(s1)
	call	print_int
	li	a0,32
	call	print_char
	lw	a0,%lo(d)(s1)
	call	print_int
	li	a0,10
	call	print_char
	li	a0,65
	call	print_char
	li	a0,68
	call	print_char
	li	a0,69
	call	print_char
	li	a0,10
	call	print_char
	li	a0,73
	call	print_char
	li	a0,74
	call	print_char
	li	a0,75
	call	print_char
	li	a0,10
	call	print_char
	lw	ra,12(sp)
	.cfi_restore 1
	lw	s0,8(sp)
	.cfi_restore 8
	lw	s1,4(sp)
	.cfi_restore 9
	lw	s2,0(sp)
	.cfi_restore 18
	li	a0,0
	addi	sp,sp,16
	.cfi_def_cfa_offset 0
	jr	ra
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.globl	d
	.globl	b
	.globl	a
	.section	.sbss,"aw",@nobits
	.align	2
	.type	d, @object
	.size	d, 4
d:
	.zero	4
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
