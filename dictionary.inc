native ".S", print
	mov rdi, rsp
	.loop:
		cmp rdi, qword[stack]
		jae next
			push rdi
			mov rdi, [rdi]
			call print_int
			call print_newline
			pop rdi
			add rdi, 8
			jmp .loop

native "+", plus
	pop rax
	add [rsp], rax
	jmp next

native "-", minus
	pop rax
	sub [rsp], rax
	jmp next

native "*", multiply
	pop rax
	pop rdx
	imul rdx, rax
	push rdx
	
	jmp next

native "/", div
	pop r9
	pop rax
	mov rdx, 0

	idiv r9

	push rax
	jmp next

native "and", and
	pop rax
	pop rdx
	
	test rax, rax
	jz .zero
		test rdx, rdx
		jz .zero
			push 1
			jmp next

	.zero:
		push 0
		jmp next

native "not", not
	pop rax
	test rax, rax

	jz .zero
		push 0
		jmp next

	.zero:
		push 1
		jmp next

	push rax
	jmp next

native "rot", rot
	pop rax		;3
	pop rdx		;2
	pop rdi		;1

	push rdx	;2
	push rax	;3
	push rdi	;1

	jmp next

native "swap", swap
	pop rax		;2
	pop rdx		;1

	push rax	;2
	push rdx	;1

	jmp next

native "dup", dup
	push qword[rsp]

	jmp next

native "drop", drop
	pop rax

	jmp next

native ".", print_num
	pop rdi
	call print_int
	call print_newline

	jmp next