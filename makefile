all: out

words.o:
	nasm -felf64 words.nasm

utilFunc.o:
	nasm -felf64 utilFunc.nasm

lib.o:
	nasm -felf64 lib.nasm 

out: words.o utilFunc.o lib.o
	ld words.o utilFunc.o lib.o
	rm words.o utilFunc.o lib.o

