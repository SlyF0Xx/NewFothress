section .data
	string times 256 db 0x0
section .text

global string_length
string_length:
	mov rax, -1
	.loop:
		add rax, 1
		cmp byte[rdi+rax], 0x0		;if current symbol isn't null 
		jne .loop					;repeat
	ret

global print_string
print_string:
	mov rsi, rdi
	call string_length
	mov rdx, rax		; length
	mov rax, 1		; write
	mov rdi, 1		; stdout		
	syscall
	ret

global print_char
print_char:
	push rdi
	mov rsi, rsp	
	pop rdi
	mov rdx, 1		; length
	mov rax, 1		; write
	mov rdi, 1		; stdout		
	syscall
	ret

global print_newline
print_newline:
	mov rdi, 0xA	
	call print_char
	ret

global print_string_with_length
print_string_with_length:
	mov rdx, rdi		; length
	mov rax, 1		; write
	mov rdi, 1		; stdout		
	syscall
	ret

global print_uint
print_uint:
	mov rax, rdi		;devident
	mov rdi, 0		;count of nums
	mov rcx, 10		;devider
	.push:
		mov rdx, 0	;clear for new deviden
		div rcx		;devide
		add dl, "0"
		dec rsp				;stack can't save 1 byte
		mov byte[rsp], dl	;save num	
		inc rdi		
		cmp rax, 0	;if num have more nums 
		jne .push	;repeat
	
	mov rsi, rsp
	push rdi
	call print_string_with_length
	pop rdi
	add rsp, rdi
	ret	

global print_int
print_int:
	push rdi
	test rdi, rdi
	jns .uint
	mov rdi, "-"
	call print_char
	pop rdi
	not rdi
	inc rdi
	call print_uint
	ret
	.uint:
		pop rdi	
		call print_uint
		ret

global string_equals
string_equals:
	mov rax, 0
	jmp .start
	.loop:
		inc rdi
		inc rsi
	.start:
		mov al, byte[rsi]
		cmp byte[rdi], al
		jne .fail
		cmp byte[rdi], 0				;if it end of string
		jne .loop
	mov rax, 1
	ret	
	
	.fail:
	mov rax,0
	ret

global read_char
read_char:
	dec rsp
	mov rsi, rsp	
	mov rdx, 1		; length
	mov rax, 0		; read
	mov rdi, 0		; stdin		
	syscall
	test rax, rax
	je .end
		mov rax, 0
		mov al, byte[rsp]
	.end:
		inc rsp
		ret

global read_word		
read_word:
	push rdi
	push rsi
	.skip:	
		call read_char
		cmp al, 0x09		;tab
		je .skip
		cmp al, 10			;enter
		je .skip
		cmp al, 32			;space
		je .skip
		cmp al, 0
		je .fail
	mov rdx, 0			
	pop rsi
	pop rdi
	.read:
		mov byte[rdi+rdx], al 
		inc rdx	
		cmp rdx, rsi
		je .stop
		
		push rdx 
		push rdi
		push rsi
		call read_char
		pop rsi
		pop rdi
		pop rdx
	

		cmp al, 0x09
		je .end
		cmp al, 10
		je .end
		cmp al, 32
		je .end
		cmp al, 0
		je .end
		
		jmp .read
	.end:
		mov byte[rdi+rdx], 0
		mov rax, rdi
		ret
	.fail:
		pop rsi
		pop rdi
		mov byte[rdi], 0
		mov rax, rdi
		mov rdx, 0
		ret
	.stop:
		mov rdx, rsi
		mov rax, 0
		ret

global parse_uint		
parse_uint:
	mov rax, 0	
	mov r9, rdi
	
	.loop:
		cmp byte[r9], "0"
		js .end
		cmp byte[r9], "9"+1
		jns .end
		
		mov r8, 10
		mul r8
		
		add al, byte[r9]
		sub al, "0"
		
		inc r9
		jmp .loop
		
	.end:
		mov rdx, r9 
		sub rdx, rdi
		ret

global parse_int
parse_int:
	mov rax, 0
	mov rdx, 0
	
	cmp byte[rdi], "-"			;if negative
	je .neg						;go to negative parsing
	call parse_uint
	ret
	
	.neg:
		inc rdi
		cmp byte[rdi], "0"
		js .end
		cmp byte[rdi], "9"+1
		jns .end
		call parse_uint
		not rax
		inc rax
		inc rdx
	.end:
		ret


global string_copy
string_copy:
	mov rax, 0
	jmp .start
	.loop:
		inc rdi
		inc rsi
	.start:
		mov al, byte[rdi]
		mov byte[rsi], al
		cmp byte[rdi], 0			;if it end of string
		jne .loop
	ret
