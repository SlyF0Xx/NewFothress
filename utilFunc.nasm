extern last
extern string_length
extern string_equals

section .code

section .code
global find
find:
	mov rsi, [last]
	.loop:
		cmp rsi, 0
		je .end
			push rdi
			push rsi
			add rsi, 8

			call string_equals

			pop rsi
			pop rdi

			cmp rax, 0
			je .step
				mov rax, rsi
				ret
			.step:
				mov rsi, [rsi]
				jmp .loop

		.end:
			mov rax, 0
			ret














global cfa
cfa:
	add rdi, 8	; 8 - link
	push rdi

	call string_length

	pop rdi

	add rax, rdi
	add rax, 2		; 1 - флаг 1 - конец строки
	
	ret