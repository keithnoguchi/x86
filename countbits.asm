; SPDX-License-Identifier: GPL-2.0
	section	.data
data	dq	0xfedcba9876543210	; example data for bit counting
want	dd	32			; 32 ones in data above
	section	.text
	global	main
	extern	atoi
main
	push	rbp
	mov	rbp, rsp
	sub	rsp, 16
	cmp	rdi, 3
	jne	.else
	mov	rdi, [rsi+8]
	mov	[rsp], rsi
	call	atoi
	mov	rdx, rax
	mov	rsi, [rsp]
	mov	rdi, [rsi+16]
	call	atoi
	mov	[rsp], rax
	jmp	.done
.else
	mov	rdx, [data]
	mov	eax, [want]
	mov	[rsp], rax
.done	xor	eax, eax
	xor	ebx, ebx
	mov	ecx, 64
.while	bt	edx, 0
	setc	bl
	add	eax, ebx
	shr	rdx, 1
	sub	ecx, 1
	jnz	.while
	cmp	eax, [rsp]
	jne	.out
	xor	eax, eax
.out	leave
	ret
