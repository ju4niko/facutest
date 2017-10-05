;################################################################################
;#	Título: Ejemplo basico de inicio desde BIOS									#
;#																				#
;#	Versión:		2.0							Fecha: 	22/08/2015				#
;#	Autor: 			D. Garcia					Tab: 	4						#
;#	Compilación:	Usar Makefile												#
;#	Uso: 			-															#
;#	------------------------------------------------------------------------	#
;#	Descripción:																#
;#		Inicializacion de un sistema basico desde BIOS							#
;#		Genera una BIOS ROM de 64kB para inicializacion y codigo principal		#
;#	------------------------------------------------------------------------	#
;#	Revisiones:																	#
;#		2.0 | 22/08/2015 | D.GARCIA | Inicio desde BIOS. Cambio de VMA			#
;#		1.0 | 04/03/2013 | D.GARCIA | Inicial									#
;#	------------------------------------------------------------------------	#
;#	TODO:																		#
;#		-																		#
;################################################################################

%define		STACK_ADDR		0x00140000	; Direccion fisica para la pila
%define 	STACK_SIZE		32*1024		; 32kB

;********************************************************************************
; Simbolos externos y globales
;********************************************************************************
GLOBAL 		Entry
EXTERN		__sys_tables_LMA
EXTERN		__sys_tables_start
EXTERN		__sys_tables_end
EXTERN		__main_LMA
EXTERN		__main_start
EXTERN		__main_end
EXTERN		__mdata_LMA
EXTERN		__mdata_start
EXTERN		__mdata_end
EXTERN		__bss_start
EXTERN		__bss_end
EXTERN		start32
;----de mi funcion c
EXTERN	__funcion_LMA				; Puntero al inicio de la LMA, solo parte baja 
EXTERN	__funcion_start			; Puntero a la VMA
EXTERN	__funcion_end

;-------------------

;********************************************************************************
; Seccion de codigo de inicializacion
;********************************************************************************
USE16
SECTION 	.reset_vector					; Reset vector del procesador

Entry:										; Punto de entrada definido en el linker
	jmp 	dword start						; Punto de entrada de mi BIOS
	times   16-($-Entry) db 0				; Relleno hasta el final de la ROM

;********************************************************************************
; Seccion de codigo de inicializacion
;********************************************************************************
USE32
SECTION 	.init
;--------------------------------------------------------------------------------
; Punto de entrada
;--------------------------------------------------------------------------------
start:									; Punto de entrada
	INCBIN "init16.bin"					; Binario de 16 bits

	;xchg bx, bx							; Magic breakpoint
										; Inicializo tablas de sistema en asm
										; mover codigo a direccion virutal VMA ya que no 
										; se puede resolver en tiempo de compilacion
	mov 	esi, __sys_tables_LMA		; Puntero al inicio de la LMA, solo parte baja 
	mov 	edi, __sys_tables_start		; Puntero a la VMA
	mov		ecx, __sys_tables_end
	sub		ecx, __sys_tables_start		; Calculo tamaño
	rep		movsb	

	mov 	esi, __main_LMA				; Puntero al inicio de la LMA, solo parte baja 
	mov 	edi, __main_start			; Puntero a la VMA
	mov		ecx, __main_end	
	sub		ecx, __main_start			; Calculo tamaño
	rep		movsb	
	
	;+++++++++++++++++++++++++
	;mi funcion en c
	;++++++++++++++++++++++++
	mov 	esi, __funcion_LMA				; Puntero al inicio de la LMA, solo parte baja 
	mov 	edi, __funcion_start			; Puntero a la VMA
	mov		ecx, __funcion_end
	sub		ecx, __funcion_start			; Calculo tamaño
	rep		movsb	
	;++++++++++++++++++++++++
	
	mov 	esi, __mdata_LMA			; Puntero al inicio de la LMA, solo parte baja 
	mov 	edi, __mdata_start			; Puntero a la VMA
	mov		ecx, __mdata_end	
	sub		ecx, __mdata_start			; Calculo tamaño
	rep		movsb	
	
	xor		ax, ax
	mov 	edi, __bss_start			; Puntero a la VMA
	mov		ecx, __bss_end	
	sub		ecx, __bss_start			; Calculo tamaño
	rep		stosb
	
	lgdt	[gdtr]						; Recargo nueva GDT
	lidt	[idtr]						; Cargo IDT

	mov 	ax, DS_SEL
	mov 	ss, ax						; Inicializo selector de pila
	mov 	esp, STACK_ADDR + STACK_SIZE	; Inicializo la pila

	mov 	bx, 0x2028					; Base de los PICS
	call 	InitPIC						; Inicializo controlador de interrupciones
	
	mov 	eax, start32				; VMA de entrada
	push 	dword CS_SEL_32
	push 	eax
	retf								; Salto a main32

;--------------------------------------------------------------------------------
; Inicializacion del controlador de interrupciones
; Corre la base de los tipos de interrupción de ambos PICs 8259A de la PC a los 8 tipos consecutivos a 
; partir de los valores base que recibe en BH para el PIC Nº1 y BL para el PIC Nº2.
; A su retorno las Interrupciones de ambos PICs están deshabilitadas.
;--------------------------------------------------------------------------------
InitPIC:
										; Inicialización PIC Nº1
										; ICW1
	mov		al, 11h         			; IRQs activas x flanco, cascada, y ICW4
	out     20h, al  
										; ICW2
	mov     al, bh          			; El PIC Nº1 arranca en INT tipo (BH)
	out     21h, al
										; ICW3
	mov     al, 04h         			; PIC1 Master, Slave ingresa Int.x IRQ2
	out     21h, al
										; ICW4
	mov     al, 01h         			; Modo 8086
	out     21h, al
										; Antes de inicializar el PIC Nº2, deshabilitamos 
										; las Interrupciones del PIC1
	mov     al, 0FFh
	out     21h, al
										; Ahora inicializamos el PIC Nº2
										; ICW1
	mov     al, 11h        			  	; IRQs activas x flanco,cascada, y ICW4
	out     0A0h, al  
										; ICW2
	mov    	al, bl          			; El PIC Nº2 arranca en INT tipo (BL)
	out     0A1h, al
										; ICW3
	mov     al, 02h         			; PIC2 Slave, ingresa Int x IRQ2
	out     0A1h, al
										; ICW4
	mov     al, 01h         			; Modo 8086
	out     0A1h, al
										; Enmascaramos el resto de las Interrupciones 
										; (las del PIC Nº2)
	mov     al, 0FFh
	out     0A1h, al
	ret

;********************************************************************************
; Tablas de sistema
;********************************************************************************
SECTION		.sys_tables 	progbits
ALIGN 4

;--------------------------------------------------------------------------------
; GDT
;--------------------------------------------------------------------------------
GDT:
NULL_SEL	equ		$-GDT
	dq		0x0

CS_SEL_32   equ 	$-GDT
	dw 		0xFFFF 
	dw 		0x0000
	db 		0x00
	db 		0x9A
	db 		0xCF
	db 		0
		
DS_SEL  	equ 	$-GDT
	dw 		0xFFFF 
	dw 		0x0000
	db 		0x00
	db 		0x92
	db 		0xCF
	db 		0

GDT_LENGTH 	equ 	$-GDT

;--------------------------------------------------------------------------------
; IDT
;--------------------------------------------------------------------------------
IDT:
	times 	32 		dq 0,0 
		
IDT_LENGTH  equ 	$-IDT

gdtr:
	dw 		GDT_LENGTH-1
	dd 		GDT

idtr:
	dw 		IDT_LENGTH-1
	dd 		IDT

;********************************************************************************
; 						-  -- --- Fin de archivo --- --  -
; 
;********************************************************************************
