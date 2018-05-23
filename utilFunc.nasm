extern last
extern string_length
extern string_equals

section .code
global find_word
find_word:
	mov rdi, last
	call find_word_t
	ret

find_word_t:
	cmp rsi, 0
	je end_loop	
		push rdi
		push rsi

		add rsi, 8

		call string_equals 

		pop rsi
		pop rdi

		cmp rax, 1
		je success
			mov rsi, qword[rsi]
			call find_word_t
			ret

		success:
			mov rax, rsi
			ret

	end_loop:
		mov rax, 0
		ret



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