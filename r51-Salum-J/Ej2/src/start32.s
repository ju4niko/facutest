SECTION .start32 progbits

USE32									; Codigo de 32bits

EXTERN	__STACK_END_32
EXTERN	__STACK_SIZE_32
EXTERN	CS_SEL_32
EXTERN	DS_SEL
EXTERN	kernel32_init

GLOBAL start32_launcher

start32_launcher:
	; Inicializo selectores de dato
	mov	ax,DS_SEL
	mov	ds,ax
	mov	es,ax
	mov 	gs, ax
	mov 	fs, ax

	; Inicializo de la pila
	mov	ss,ax							; Intel recomienda luego de esta linea mover al stack pointer por si llega a haber una interrupcion
									; asi termina de ejecutar esta instruccion y me queda la pila completa
	mov	esp,__STACK_END_32
	xor	eax, eax
	mov	ecx,__STACK_SIZE_32

	; Cargo la pila con ceros
	.stack_init:
		push	eax
		loop	.stack_init

	mov	esp,__STACK_END_32					; Ubico el stack pointer
	jmp	CS_SEL_32:kernel32_init					; Salto al programa en modo protegido ya inicializado el procesador y los registros correctamente

