.PHONY : clean


bootdisk: bootld.bin
	dd if=/dev/zero of=bochs_td3.img count=1	
	dd if=bootld.bin of=bochs_td3.img conv=notrunc

bootld.bin: helloboot.asm
	nasm -f bin  helloboot.asm -l helloboot.lst -o $@

clean:
	rm -f bootld.bin bochs_td3.img *.lst
