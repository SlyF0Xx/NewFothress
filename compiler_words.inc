 native ":", colon
 	mov rax, [here]
	mov rdx, [last]
	mov [rax], rdx					;write link to word
	mov [last], rax					;update link


	add qword[here], 8				;8 - link 
	mov rdi, [here] 				;name
	mov rsi, 256
	call read_word

	add [here], rdx
	add qword[here], 10 			; byte - flag byte - terminator 8 - docol
	mov rax, [here]
	mov byte[rax - 9], 0 		;flag
	mov qword[rax - 8], docol

	mov byte[state], 1

	jmp next

native ";", end, Immediate
	mov rdx, xt_exit

	mov rax, [here]
	mov [rax], rdx

	add qword[here], 8
	mov byte[state], 0

	jmp next

native "num", num
	push qword[pc]
	add pc, 8

	jmp next

native "branch", branch, Branch
	mov rax, qword[pc]
	mov rdi, 8
	mul rdi

	add pc, rax
	add pc, 8

	jmp next

native "branch0", branch_if, Branch
	pop rax
	test rax, rax
	jz .success
		add pc, 8
		jmp next
	.success:
		mov rax, qword[pc]
		mov rdi, 8
		mul rdi

		add pc, rax
		add pc, 8

		jmp next


