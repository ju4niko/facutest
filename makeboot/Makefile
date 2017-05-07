.PHONY : clean

KERNEL_MEMORY=0x1000
KERNEL_SIZE_SECTORS=10

BOOTLOADER_DEFINES=-DKERNEL_SIZE_SECTORS=$(KERNEL_SIZE_SECTORS) -DKERNEL_MEMORY=$(KERNEL_MEMORY)

bootdisk: kernel.bin bootld.bin
	dd if=/dev/zero of=bochs_td3.img count=$(KERNEL_SIZE_SECTORS)	
	dd if=bootld.bin of=bochs_td3.img conv=notrunc
	dd if=kernel.bin of=bochs_td3.img seek=1 conv=notrunc

kernel.bin: kernel.asm
	nasm -f bin $(BOOTLOADER_DEFINES) kernel.asm -l kernel.lst -o $@

bootld.bin: bootld.asm
	nasm -f bin $(BOOTLOADER_DEFINES) bootld.asm -l bootld.lst -o $@

clean:
	rm -f bootld.bin kernel.bin bochs_td3.img *.lst
