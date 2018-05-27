extern find
extern print_uint
extern print_string
extern read_word
extern parse_int
extern cfa
extern print_int
extern print_newline
extern read_char
extern print_char
extern string_length
extern print_string_with_length
extern string_copy

global last

%define Immediate 1
%define Branch 2

section .data
	%include "macro.inc"
	%include "compiler_words.inc"
	%include "dictionary.inc"
	%include "colon.inc"


section .data	
	last: dq link
	test_word: db "-", 0
	
	program_stub: dq 0
	xt_interpreter: dq .interpreter
	.interpreter: dq interpreter_loop

	current_word: times 256 db 0x0
	erorr: db "Error! Word not found", 0

	stack: dq 0
	memory: times 65536 dq 0x0
	return_stack: times 256 dq 0x0
	top_stack: dq return_stack
	xt_exit: dq exit

	test: db "test", 0
	test_field: times 256 db 0

	words: times 65536 dq 0x0
	here: dq words
	prev_word: db 0
	state: db 0


section .code
global _start


exit:
	sub rstack, 8
	mov pc, [rstack]

	jmp next


next:
	mov w, pc
	add pc, 8 ; предполагая размер ячейки 8 байт
	mov w, [w]

	jmp [w]



interpreter_loop:
	mov rdi, current_word
	mov rsi, 256
	call read_word 

	cmp rdx, 0
	je .end

	mov rdi, rax
	call find

	cmp rax, 0
	je .not_word
		mov rdi, rax
		call cfa

		cmp byte[state], 0					; if now compile part
		je .exec
				;	compile part
			mov dl, byte[rax - 1]
			mov [prev_word], dl

			cmp rdx, Immediate				; if this word - Immediate
			je .exec
				mov rdx, [here]
				mov [rdx], rax
				add qword[here], 8
		
				jmp interpreter_loop
		.exec:
				; interpret part
			mov [program_stub], rax
			mov pc, program_stub
			jmp next

	.not_word:
		mov rdi, current_word
		call parse_int

		cmp rdx, 0
		je .not_found
			cmp byte[state], 0					; if now compile part
			je .exec_num
					;	compile part with num
				cmp byte[prev_word], Branch
				je .branch
					mov rdx, [here]
					mov qword[rdx], xt_num
					add qword[here], 8
					mov rdx, [here]
					mov [rdx], rax
					add qword[here], 8

					jmp interpreter_loop
				.branch:
					mov rdx, [here]
					mov [rdx], rax
					add qword[here], 8

					mov byte[prev_word], 0

					jmp interpreter_loop
			.exec_num:
					; interpreter part with num
				push rax
				jmp interpreter_loop



		.not_found:
			mov rdi, erorr
			call print_string
			jmp interpreter_loop
	.end:
		mov rax, 60
		mov rdi, 0
		syscall

_start:
	mov rstack, return_stack
	;mov rstack, end_of_stack - 8
	
	mov [stack], rsp

	mov pc, xt_interpreter
	jmp next

	
	mov rax, 60
	mov rdi, 0
	syscall
