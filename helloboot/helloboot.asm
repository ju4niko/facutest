[ORG 0x7C00];donde lo deja el BIOS


[BITS 16]   			;modo default del procesador

	xchg	bx, bx		;magic breakpoint
	cli		        	;clear interrupts
;-----------------------------------------------------------
; inic
	mov		ah, 0x13	;funcion print string de BIOS
	mov		cx, len		;longtud del mensaje
	mov 	al,01h      ; mover cursor
	mov 	bl,0bh      ; color magenta
	mov 	dh,17        ; fila
	mov 	dl,4        ; columna 
	push	ds
	pop		es
	mov		bp,msg		;puntero al mensae
	int 	10h         ; servicio BIOS
			
	hlt
	
msg     db  0xa,'Hola mundo en asm!',0xa,0xa		;mensaje
len     equ $ - msg 
;***********************************************************
;	firma de boot sector
    times   510-($-$$)  db 0 	;rellena hasta terminar un sector de 512 
								;con ceros
    dw 0xAA55   				;la firma propiamente dicha
