all: hello.out

hello.out: hello.asm
	nasm -f elf64 -l hello.lst hello.asm
	nasm -f elf64 -l hello-rutinas.lst hello-rutinas.asm
	nasm -f elf64 -l hellodata.lst hellodata.asm
	nasm -f elf64 -l hellodata2.lst hellodata2.asm
	
	ld -T hello.ls
	
clean:
	rm -f hello
	rm -f *.o
	rm -f *.lst
	
