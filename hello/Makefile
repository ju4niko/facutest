all: hello.out

hello.out: hello.asm
	nasm -f elf64 -l hello.lst hello.asm
	ld -o hello hello.o
	
clean:
	rm -f hello
	rm -f hello.o
	
