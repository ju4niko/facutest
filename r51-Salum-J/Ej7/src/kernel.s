SECTION .kernel32 progbits

USE32									; Codigo de 32bits

; Funciones externas
EXTERN	clrsrc
EXTERN	print

GLOBAL	kernel32_init

; Variables
const_string	db	'Hola mundo'
color		db	0x00

kernel32_init:	
	; Preparo la pila y llamo a la funcion para limpiar la pantalla
	xchg bx,bx
	push	ebp
	mov	ebp,esp
	call	clrsrc
	mov	esp,ebp
	pop	ebp
	
	; Preparo la pila y llamo a la funcion para escribir en pantalla
	xchg bx,bx
	push	ebp
	mov	ebp,esp
	; Cargo la pila con los parametros de la funcion para escribir la pantalla
	push	color							; Cargo el color
	push	0x00							; Cargo la fila donde comenzar escribir
	push	0x00							; Cargo la columna donde comenzar a escribir
	push	const_string						; Cargo el string a escribir
	call	print
	mov	esp,ebp
	pop	ebp
	xchg bx,bx

ACA:									; Retengo programa
	hlt
	jmp ACA
