%define link 0
%macro update_link 0
%%link: dq link
%define link %%link
%endmacro


%macro native 3
section .data
w_%+ %2:
	update_link
	db %1, 0
	db %3
xt_%+ %2:
	dq i_%+ %2 

section .code
	i_%+ %2:
%endmacro


%macro native 2
	native %1, %2, 0
%endmacro



%macro colon 3
section .data
w_%+ %2:
	update_link
	db %1, 0
	%3
xt_%+ %2:
	dq docol

%endmacro

%macro colon 2
	colon %1, %2, 0
%endmacro


global last

section .data
	%include "dictionary.inc"

section .data	
	last: dq link
	test_word: db "-", 0
	
	program_stub: dq 0
	xt_interpreter: dq .interpreter
	.interpreter: dq interpreter_loop

	current_word: times 256 db 0x0
	erorr: db "Error! Word not found", 0

	stack: dq 0

	test: db "test!", 0



%define w r15
%define pc r14
%define rstack r13

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

section .code
global _start

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

		mov [program_stub], rax
		mov pc, program_stub
		jmp next

	.not_word:
		mov rdi, current_word
		call parse_int

		cmp rdx, 0
		je .not_found
			push rax
			jmp interpreter_loop
		.not_found
			mov rdi, erorr
			call print_string
			jmp interpreter_loop
	.end
		mov rax, 60
		mov rdi, 0
		syscall

_start:
	mov [stack], rsp

	mov pc, xt_interpreter
	jmp next

	
	mov rax, 60
	mov rdi, 0
	syscall
