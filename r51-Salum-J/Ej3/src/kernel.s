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
	push	ebp
	mov	ebp,esp
	call	clrsrc
	mov	esp,ebp
	pop	ebp
	
	; Preparo la pila y llamo a la funcion para escribir en pantalla
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

	;--------------------------------------------------------------------------------------------------------------------;
	; Generacion de los diferentes tipos de excepcion

	; Divide Error Exception #DE
	;xchg	bx,bx
	;mov	ax,0x01
	;mov	bx,0x00
	;div	bx
	
	; Invalid Opcode Exception #UD
	;xchg	bx,bx
	;ud2
	
	; Double Fault Exception #DF
	;xchg	bx,bx
	;mov	ax,0x01
	;mov	bx,0x00
	;div	bx
	
	; General Protection Exception #GP
	xchg	bx,bx
	mov	ax,0x00
	mov	cs,ax
	
	; Page-Fault Exception #PF
	;xchg	bx,bx
	; Tendria que activar la paginacion primero...
	
	;--------------------------------------------------------------------------------------------------------------------;
	
ACA:									; Termino el programa
	hlt
	jmp ACA
