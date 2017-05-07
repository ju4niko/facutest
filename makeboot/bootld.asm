;***********************************************************
;   UTN-TD3-BOOTLOADER
;***********************************************************
;   Assembler: 
;           nasm
;   To assemble bootable disk: 
;           make bootdisk
;   To assemble bootloader code:
;	    make bootloader

[ORG 0x7C00];BIOS carga el bootsector a partir de esta direccion

%ifndef KERNEL_MEMORY
	%error "la direccion de inicio del kernel debe estar definida"
	
%endif	

%ifndef KERNEL_SIZE_SECTORS
	%error "tamaño del kernel en secrores no definido"
%endif	

[BITS 16]   ;for real mode; 16-bit instructions

	xchg	bx, bx	;magic breakpoint
	cli		                       ;clear interrupts
;-----------------------------------------------------------
; INITIALIZATION PROCEDURES

	

	mov	ah, 02h			; load int 13h function (read sector)
	mov	al,KERNEL_SIZE_SECTORS  ; load how many sectors will be read
	mov	cx, 02h			; starting from track 0, sector 2
	mov	dh, 0			; load head = 0
	mov 	dl, 0 			; drive 0 (A:)
	mov	ebx, KERNEL_MEMORY	; load linear destination address at ebx
	shr	ebx,4			; shift right ebx (result at BX will be the segment)
	mov	es,bx			; load destination segment
	mov	bx, 0			; load 0 offset  
	int	13h			; read disk
	jc	error			; if carry is set, int 13h didn't work
	jmp     (KERNEL_MEMORY>>4):0    ; jmp to the kernel code
error:
	hlt
;***********************************************************
; For the file to be identified as a valid boot sector,
; the file must be of size 512 bytes, and the word at 510
;' must be 0xAA55.
    times   510-($-$$)  db 0 ;fill the space till 510 
                             ;with zeroes

    dw 0xAA55                ;boot sector identifier
