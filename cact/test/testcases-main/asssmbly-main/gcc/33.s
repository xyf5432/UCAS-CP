	.file	"33.cact"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	inc_a
	.type	inc_a, @function
inc_a:
.LFB0:
	.cfi_startproc
	lui	a5,%hi(a)
	lw	a0,%lo(a)(a5)
	addi	a0,a0,1
	sw	a0,%lo(a)(a5)
	ret
	.cfi_endproc
.LFE0:
	.size	inc_a, .-inc_a
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
.LFB1:
	.cfi_startproc
	lui	a1,%hi(a)
	lw	a5,%lo(a)(a1)
	lui	a6,%hi(b)
	li	a4,1
	addi	a3,a5,2
	lw	a0,%lo(b)(a6)
	bgtu	a3,a4,.L4
.L7:
	addi	a5,a0,2
	li	a4,1
	slli	a3,a0,1
	bgtu	a5,a4,.L41
.L6:
	addi	a5,a3,2
	li	a4,1
	slli	a2,a3,1
	bgtu	a5,a4,.L42
.L10:
	addi	a5,a2,2
	li	a4,1
	slli	a3,a2,1
	bgtu	a5,a4,.L43
.L13:
	addi	a5,a3,2
	li	a4,1
	slli	a2,a3,1
	bgtu	a5,a4,.L44
.L16:
	addi	a5,a2,2
	li	a4,1
	slli	a3,a2,1
	bgtu	a5,a4,.L45
.L19:
	sw	a3,%lo(a)(a1)
	mv	a5,a3
	slli	a3,a3,1
.L21:
	sw	a3,%lo(b)(a6)
	mv	a0,a3
.L22:
	add	a0,a0,a5
	ret
.L4:
	addi	a5,a5,3
	beq	a5,zero,.L7
	add	a5,a5,a0
	li	a4,12
	ble	a5,a4,.L7
	addi	a5,a5,8
	mv	a3,a0
	li	a4,0
.L8:
	add	a5,a5,a3
	li	a2,12
	ble	a5,a2,.L6
	addi	a5,a5,8
	mv	a2,a3
.L11:
	add	a5,a5,a2
	li	a3,12
	ble	a5,a3,.L10
	addi	a5,a5,8
	mv	a3,a2
.L14:
	add	a5,a3,a5
	li	a2,12
	ble	a5,a2,.L13
	addi	a5,a5,8
	mv	a2,a3
.L17:
	add	a5,a2,a5
	li	a3,12
	ble	a5,a3,.L16
	addi	a5,a5,8
	mv	a3,a2
.L20:
	add	a5,a5,a3
	li	a2,12
	ble	a5,a2,.L19
	addi	a5,a5,5
	sw	a5,%lo(a)(a1)
	beq	a4,zero,.L22
	j	.L21
.L41:
	addi	a5,a0,3
	beq	a5,zero,.L6
	j	.L8
.L45:
	addi	a5,a2,3
	beq	a5,zero,.L19
	j	.L20
.L44:
	addi	a5,a3,3
	beq	a5,zero,.L16
	j	.L17
.L43:
	addi	a5,a2,3
	beq	a5,zero,.L13
	j	.L14
.L42:
	addi	a5,a3,3
	beq	a5,zero,.L10
	j	.L11
	.cfi_endproc
.LFE1:
	.size	main, .-main
	.globl	b
	.globl	a
	.section	.sdata,"aw"
	.align	2
	.type	b, @object
	.size	b, 4
b:
	.word	1
	.type	a, @object
	.size	a, 4
a:
	.word	-1
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
