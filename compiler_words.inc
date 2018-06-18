native "docol", docol
	mov [rstack], pc
	add rstack, 8

	mov pc, w
	add pc, 8

	jmp next

native "push_docol", push_docol
	push i_docol

	jmp next

colon "'", find, Immediate
	dq xt_tmp_str
	dq xt_dup
	dq xt_read_word
	dq xt_drop
	dq xt_find_word
	dq xt_dup
	dq xt_branch_if
	dq 8
		dq xt_cfa
		dq xt_state
		dq xt_branch_if
		dq 4 
			dq xt_num		;	
			dq xt_num		;	create's dq xt_lit
			dq xt_add_xt	;

			dq xt_add_xt
	dq xt_exit

native "Immediate", imm_flag
	push Immediate

	jmp next

native "create", create
 	mov rax, [here]
	mov rdx, [last]
	mov [rax], rdx					;write link to word
	mov [last], rax					;update link

	add qword[here], 8				;8 - link 

	mov rdi, [rsp]
	call string_length

	pop rdi							; name
	push rax

	mov rsi, [here]
	call string_copy

	pop rax

	add [here], rax
	add qword[here], 2 				; byte - flag byte - terminator 8 - docol
	mov rax, [here]
	
	pop rdi							; flag (actualy - 1 byte)
	mov byte[rax - 1], dil 		

	jmp next

native ",", add_xt
	pop rax
	add qword[here], 8
	mov rdx, [here]
	mov [rdx - 8], rax

	jmp next

native "c,", add_char
	mov al, [rsp]
	add rsp, 1

	add qword[here], 8
	mov rdx, [here]
	mov [rdx - 8], al

	jmp next

colon ":", colon
	dq xt_imm_flag
	dq xt_tmp_str
	dq xt_read_word
	dq xt_drop
	dq xt_tmp_str
	dq xt_create

	dq xt_push_docol
	dq xt_add_xt

	dq xt_state
	dq xt_num
	dq 1
	dq xt_swap
	dq xt_write_mem

	dq xt_exit


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


