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
	test: db "hell", 0





%define w r12
%define pc r13
%define rstack r14

extern find
extern print_uint
extern print_string


section .code
global _start


_start:
	mov rax, w_minus
	mov [last], rax

	mov rdi, test_word

	call find

	mov rdi, rax
	push rdi
	add rdi, 8
	call print_string
	pop rdi



	mov rdi, [rdi]
	add rdi, 8
	call print_string



	
	mov rax, 60
	mov rdi, 0
	syscall
