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