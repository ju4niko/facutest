all: hello.out

hello.out: hello.asm
	nasm -f elf64 -l hello.lst hello.asm
	nasm -f elf64 -l hellodata.lst hellodata.asm
	ld -T hello.ls
	
clean:
	rm -f hello
	rm -f *.o
	rm -f *.lst
	
