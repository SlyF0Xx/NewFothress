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
	cmp rax, 0
	cqo
	idiv r9

	push rax
	jmp next

native "=", equals
	pop rax
	pop rdx
	cmp rax, rdx
	je .eq
		push 0
		jmp next
	.eq:
		push 1
		jmp next	

native "<", less
	pop rax
	pop rdx
	cmp rdx, rax
	jb .less
		push 0
		jmp next
	.less:
		push 1
		jmp next	

native "&&", land
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

native "key", key
	call read_char

	sub rsp, 1
	mov [rsp], al

	jmp next

native "emit", emit
	mov rdi, 0
	mov dil, [rsp]
	add rsp, 1

	call print_char
	call print_newline

	jmp next

native "number", number
	mov rdi, current_word
	mov rsi, 256
	call read_word 

	cmp rdx, 0
	je .end

		mov rdi, current_word
		call parse_int
		push rax

		jmp next

	.end:
		mov rax, 60
		mov rdi, 0
		syscall

native "mem", memory
	push memory

	jmp next

native "!", write_mem
	pop rax				;address
	pop rdx				;data
	mov [rax], rdx

	jmp next

native "@", read_mem
	pop rax
	push qword[rax]

	jmp next


native "and", and
	pop rax
	AND [rsp], rax

	jmp next

native "or", or
	pop rax
	OR [rsp], rax

	jmp next

native "count", strlen
	pop rdi
	call string_length
	push rax

	jmp next

native "c!", write_char
	pop rax				; address
	pop rdx				; data

	mov [rax], rdx
	
;	mov dl, [rsp] 		; data
;	add rsp, 1
;	mov [rax], dl

	jmp next

native "c@", out_char
	pop rax				; address

	push qword[rax]

;	sub rsp, 1
;	mov dl, [rax]
;	mov [rsp], dl

	jmp next

native "word", read_word
	pop rdi				; address
	mov rsi, 256
	call read_word
	push rdx

	jmp next

native "prints", print_string
	pop rdi				; address
	call print_string
	call print_newline

	jmp next

native "printc", print_chars
	pop rdi 			; count
	pop rsi 			; address

	call print_string_with_length
	call print_newline

	jmp next

native "find", find_word
	pop rdi				; address

	call find
	push rax

	jmp next

native "cfa", cfa
	pop rdi				; address

	call cfa
	push rax

	jmp next

native "tmp_str", tmp_str
	push current_word

	jmp next

native "bye", bye
	mov rax, 60
	mov rdi, 0
	syscall

native "last_word", last_word
	push last

	jmp next

native "state", state
	push state

	jmp next

native "execute", execute
	pop rax					; address	
	
	mov [program_stub], rax
	mov pc, program_stub
	jmp next

native "here", here
	push qword[here]

	jmp next

native "r>", push
	sub qword[top_stack], 8
	pop rax
	mov rdx, [top_stack]
	mov [rdx], rax

	jmp next

native ">r", pop
	mov rdx, [top_stack]
	mov rax, [rdx]

	add qword[top_stack], 8

	push rax

	jmp next

native "syscall", syscall
	pop r9
	pop r8
	pop r10
	pop rdx
	pop rsi
	pop rdi
	pop rax

	syscall
	
    push rax
    push rdx

	jmp next