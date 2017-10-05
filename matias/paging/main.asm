;################################################################################
;#	Título: Codigo principal de la aplicacion de 32 bits						#
;#																				#
;#	Versión:		1.0							Fecha: 	27/04/2015				#
;#	Autor: 			D. Garcia					Tab: 	4						#
;#	Compilación:	Usar Makefile												#
;#	Uso: 			-															#
;#	------------------------------------------------------------------------	#
;#	Descripción:																#
;#	------------------------------------------------------------------------	#
;#	Revisiones:																	#
;#		1.0 | 27/04/2015 | D.GARCIA | Inicial									#
;#	------------------------------------------------------------------------	#
;#	TODO:																		#
;#		-																		#
;################################################################################
extern clrscr
extern Print_c ;funcion en c para eprobar escribir 
extern create_page_directory	 ; definida en Funciones.c
extern create_page_table		  ; definida en Funciones.c
extern set_page_directory		; definida en Funciones.c
extern PaginarKernel		; definida en Funciones.c
;--------------------------------------------------------------------------------
; Macros
;--------------------------------------------------------------------------------
%define 	VGA_RAM		0xB8000

;--------------------------------------------------------------------------------
; Simbolos externos
;--------------------------------------------------------------------------------

GLOBAL		start32
global 		TECLA_LEIDA
global texto_error
global texto_DE
global texto_DB
global texto_NMI
global texto_BP
global texto_OF
global texto_BR
global texto_UD
global texto_NM
global texto_DF
global texto_09
global texto_TS
global texto_NP
global texto_SS
global texto_GP
global texto_PF
global texto_MF
global texto_AC
global texto_MC
global texto_XF

extern	irq_0_handler
extern 		print
extern 		cleansc
extern		MI_gdtr
extern		MI_IDT
extern		MI_idtr
extern		Desc_Dato32b	
extern		Desc_codigo32b
extern		Desc_Stack32b
extern		handler_vector
extern		idt_vector
extern		vector_end
extern 		Timer_Config

;********************************************************************************
; Datos
;********************************************************************************
SECTION 	.data	
TECLA_LEIDA db 0x00	
msgInicio 	db "MI PRIMER PROGRAMA DESDE BIOS ....", 0
msgIntON    db "las interrupciones han sido activadas....", 0
msgPrueba_C 	db "el sistema esta esta corriendo presione una tecla fede gato", 0
msgEndProgram db "El programa finalizao correctamente...Adios..", 0
;string de sistema para las interrupciones
texto_error db "Ninguna excepcion.....",0
texto_DE: 	db "Excepcion #DE generada",0  	; IRQ 0
texto_DB: 	db "Excepcion #DB generada",0  	; IRQ 1
texto_NMI: 	db "Interrupcion NMI      ",0	; IRQ 2 
texto_BP: 	db "Excepcion #BP generada",0  	; IRQ 3
texto_OF: 	db "Excepcion #OF generada",0 	; IRQ 4	
texto_BR: 	db "Excepcion #BR generada",0 	; IRQ 5
texto_UD: 	db "Excepcion #UD generada",0 	; IRQ 6
texto_NM: 	db "Excepcion #NM generada",0 	; IRQ 7
texto_DF: 	db "Excepcion #DF generada",0 	; IRQ 8
texto_09: 	db "Excepcion #09 generada",0 	; IRQ 9
texto_TS: 	db "Excepcion #TS generada",0 	; IRQ 10
texto_NP: 	db "Excepcion #NP generada",0 	; IRQ 11
texto_SS: 	db "Excepcion #SS generada",0 	; IRQ 12
texto_GP: 	db "Excepcion #GP generada",0 	; IRQ 13
texto_PF: 	db "Excepcion #PF generada",0 	; IRQ 14
texto_MF: 	db "Excepcion #MF generada",0 	; IRQ 16
texto_AC: 	db "Excepcion #AC generada",0 	; IRQ 17
texto_MC: 	db "Excepcion #MC generada",0 	; IRQ 18
texto_XF: 	db "Excepcion #XF generada",0 	; IRQ 19
texto_WLL: 	db "Excepcion generada NO CONFUGURADA",0 	; WLL

;----------------------------------------------------------------

%define		DIR_PDTPK		0x000A0000			;direccion del puntero del directorio de tablas de paginas kernel (cr3)
%define		DIR_TPK			DIR_PDTPK + 0x00001000;direccion de tablas de paginas kernel


USE32
;********************************************************************************
; Codigo principal
;********************************************************************************
SECTION  	.main 	;		progbits
extern HabilitarA20 


start32:
;	xchg 	bx, bx						; Magic breakpoint
	
Cargar_MI_GDT:
	;-------------------------------------------------------
	;Cargo mi gdt que esta definida en el sys_tables.asm
	;-------------------------------------------------------
	lgdt	[MI_gdtr]						; Recargo nueva MI_GDT	
	
	
	jmp Desc_codigo32b:MI_programa	;solo si esta definido el segmento en una GDT
		
MI_programa:

	;---------------------------
	; Cargo los selectores de datos, extra-datos  y de pila 
	;---------------------------
		mov eax, Desc_Dato32b
		mov ds, eax
		mov es, eax
 
		mov ax,Desc_Stack32b
		mov ss, ax
		mov esp,0x7ffffff
		

	
	;---------------------------
	; imprimo en pantalla mensaje inicio
	;---------------------------
	;xchg	bx, bx														;magic breakpoint
	push 9 			;color
	push 0			;fila
	push 0			;columna
	push msgInicio
	call print
	pop eax
	pop eax
	pop eax
	pop eax
	;xchg	bx, bx														;magic breakpoint

	;-------------------------------------------
	; Reprogramamos el PIC 1 & 2
	;-------------------------------------------
	mov 	bx, 0x2028					; Dir base donde se encuentran los PICs

	; Init PIC N° 1
	mov		al, 0x11         			; (ICW1) IRQs activas x flanco, cascada, y ICW4
	out     0x20, al   					 
	mov     al, bh          			; (ICW2) Offset - Arranca en IRQ_32 (BH=0x20)
	out     0x21, al
	mov     al, 0x04         			; (ICW3) PIC1 Master, Slave ingresa Int.x IRQ2
	out     0x21, al
	mov     al, 0x01         			; (ICW4) Modo 8086
	out     0x21, al
										 					
	mov     al, 0xFC 					; Enmascaramos interrupciones del PIC N° 1 (menos teclado y el de timero)
	out     0x21, al
	
	; Init PIC N° 2
	mov     al, 0x11       			  	; (ICW1) IRQs activas x flanco,cascada, y ICW4
	out     0xA0, al  
	mov    	al, bl          			; (ICW2) Offset - Arranca en IRQ_40 (BH=0x28)
	
	out     0xA1, al
	mov     al, 0x02         			; (ICW3) PIC2 Slave, ingresa x Int x IRQ2
	out     0xA1, al 
	mov     al, 0x01         			; (ICW4) Modo 8086
	out     0xA1, al
										 
	mov     al, 0xFF					; Enmascaramos interrupciones del PIC N° 2
	out     0xA1, al
	


	lidt	[MI_idtr]						; Cargamos MI_idtr que esta definida en sys_tables.asm
	
	
	;-------------------------------------------------------
	;CARGO EL OFFSET DEL VECTOR DE INTERRUPCION
	;-------------------------------------------------------
		
	;xchg	bx, bx														;magic breakpoint
	xor edx,edx 						;edx=0
	

	set_handler:						;while(idt_vector!= end_of_vector)

		mov eax,[handler_vector+edx*4] 	;eax=handler_vector[edx]
		mov ebx,[idt_vector+edx*4]		;ebx=idt_vector[edx]
		cmp ebx,0xFFFFFFFF
		je inc_edx
		cmp ebx,vector_end
		je fin_init

		mov word[ebx  ],ax				;cargo el offset(15:0) del handler
		shr eax,0x10						;muevo los valores EAX(31:16) a EAX(15:0)
		mov word[ebx+6],ax				;cargo el offset(31:16) del handler

		inc_edx:
		inc edx 						;edx++

	loop set_handler

	fin_init:
		;xchg	bx, bx														;magic breakpoint

	;--------------------------------------------------
	; imprimo en pantalla que activo las interrupciones
	;--------------------------------------------------
	push 9 			;color
	push 1			;fila
	push 1			;columna
	push msgIntON
	call print
	pop eax
	pop eax
	pop eax
	pop eax

;	xchg	bx, bx														;magic breakpoint


	;
	;-------------------------------------------------------
	; Timer_config esta definida en funcion_pantalla.asm
	;-------------------------------------------------------
		call Timer_Config  ; interrupa cada 10ms
		
	;-----------------------------------------------------------------
		sti 								; Habilitamos interrupciones	
	;------------------------------------------------------------------

	;---------------------------
	; Limpio la pantalla
	;--------------------------- 
		call clrscr ; funcion en c 
		
	;-------------------------------------------------------
	; pruebo mi funcion para escribir en pantalla desde c
	;-------------------------------------------------------
	push 9 			;color
	push 1			;fila
	push 5			;columna
	push msgPrueba_C
	
	call Print_c
	pop eax
	pop eax
	pop eax
	pop eax
	
	;xchg	bx, bx														;magic breakpoint	


	;-------------------------------------------------------
	;matios_sistem es el while(1) del programa
	;-------------------------------------------------------
	
		;-----------------------
	;tengoq ue paginar
	;------------
Pagino:

 

	xchg	bx, bx														;magic breakpoint
	push 0xa0000
	call PaginarKernel
	pop eax	
	xchg	bx, bx														;magic breakpoint

	;-----------------
	;activo la paginacion con su proteccion
	 mov eax, DIR_PDTPK
		mov cr3, eax
 
		mov eax, cr0
		or eax, 0x80000001
	mov cr0, eax
	
Pagino_end:
	
	
	
			mov ecx,0
		matios_sistem:

			inc ecx
			cmp ecx,2000000
			je OUT_salir

			  jmp matios_sistem

		OUT_salir:
			jmp matios_sistem
		
	;---------------------------
	; entro a la funcion fin
	;---------------------------
	jmp fin

		
	
;*****************
;Funcion de fin de programa
;*****************
fin:
	;--------------------------------------------------
	; imprimo en pantalla que termino el programa
	;--------------------------------------------------
	push 0x01 			;color
	push 0x3			;fila
	push 0x3			;columna
	push msgEndProgram
	call print
	pop eax
	pop eax
	pop eax
	pop eax
	xchg	bx, bx														;magic breakpoint
	;nop									; Ojo con esto!!
	hlt		
	jmp 	fin
	



