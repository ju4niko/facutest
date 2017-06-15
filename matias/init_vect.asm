;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       Handler de interrupciones
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;http://www.brokenthorn.com/Resources/OSDev15.html
USE32
SECTION .text
extern 	print
extern 	MI_IDT
extern 	Desc_codigo32b
extern	TECLA_LEIDA 		;esta definida en main.asm

EXTERN texto_error
EXTERN texto_DE
EXTERN texto_DB
EXTERN texto_NMI
EXTERN texto_BP
EXTERN texto_OF
EXTERN texto_BR
EXTERN texto_UD
EXTERN texto_NM
EXTERN texto_DF
EXTERN texto_09
EXTERN texto_TS
EXTERN texto_NP
EXTERN texto_SS
EXTERN texto_GP
EXTERN texto_PF
EXTERN texto_MF
EXTERN texto_AC
EXTERN texto_MC
EXTERN texto_XF
;  Los handler de interrupciones
global 	irq_0_handler  	;IRQ 0
global 	irq_1_handler  	;IRQ 1
global 	irq_2_handler  	;IRQ 2
global 	irq_3_handler  	;IRQ 3
global 	irq_4_handler  	;IRQ 4
global 	irq_5_handler  	;IRQ 5
global 	irq_6_handler  	;IRQ 6
global 	irq_7_handler  	;IRQ 7
global 	irq_8_handler  	;IRQ 8
global 	irq_9_handler  	;IRQ 9
global 	irq_10_handler 	;IRQ 10
global 	irq_11_handler 	;IRQ 11
global 	irq_12_handler 	;IRQ 12
global 	irq_13_handler 	;IRQ 13
global 	irq_14_handler 	;IRQ 14
global 	irq_16_handler  ;IRQ 16
global 	irq_17_handler  ;IRQ 17
global 	irq_18_handler  ;IRQ 18
global 	irq_19_handler  ;IRQ 19
global	timer_handler
global 	irq_keyb_handler	; handler del teclado





%define		VERDE 			0x0A 		; Codigo de color VERDE
%define GRIS 0X07
%define 	TECLADO    		0x60 		; Dierccion E/S del buffer teclado
MS_SEGUNDOS_A_CONTAR 	equ 1000

;-------------------------------------------
; Todos los handlers...
;-------------------------------------------

;--------------------------------------------
; IRQ 0 - #DE - FAULT 		 -> DIV (Division por 0)
irq_0_handler:
	
	
;xchg	bx, bx														;magic breakpoint
	
	;pushad
	
	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_DE 		; Mensaje
	call print


	irq_0_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
		
	;popad
	;inc ecx 			; Salvamos Excepcion

	iret 

; IRQ 1 - #DB - FAULT/TRAP   -> Depuracion
irq_1_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_DB 		; Mensaje
	call print

	irq_1_handler_end:
	;popad
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	iret 

; IRQ 2 - NMI - Interrupcion -> Interrupcion no mascarable 
irq_2_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_NMI 		; Mensaje
	call print


	irq_2_handler_end:
	;popad
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	iret 

; IRQ 3 - #BP - TRAP (INT 3) -> Punto de ruptura
irq_3_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_BP 		; Mensaje
	call print


	; Salvamos Excepcion

	irq_3_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret 

; IRQ 4 - #OF - TRAP (INT 0) -> Overflow
irq_4_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_OF 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_4_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 5 - #BR - FAULT 		 -> Comprobacion de limites
irq_5_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_BR 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_5_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 6 - #UD - FAULT		 -> Codigo OP no valido
irq_6_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_UD 		; Mensaje
	call print



	; Salvamos Excepcion

	irq_6_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 7 - #NM - FAULT  		 -> Coprocesador disponible
irq_7_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_NM 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_7_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 8 - #DF - ABORT 		 -> Doble Falta
irq_8_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_DF 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_8_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	
	iret

; IRQ 9 - 09 - FAULT 		 -> Error en coma flotante
irq_9_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_09 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_9_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 10 - #TS - FAULT 		 -> TSS no valida (para conmutacion de tareas)
irq_10_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_TS 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_10_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	
	iret

; IRQ 11 - #NP - FAULT 		 -> Error en carga de segmento
irq_11_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_NP 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_11_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	
	iret

; IRQ 12 - #SS - FAULT 		 -> Error en operaciones de pila y selctor SS
irq_12_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_SS 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_12_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 13 - #GP - FAULT		 -> Eerror en referencia a memoria y proteccion
irq_13_handler:

	;pushad
															;magic breakpoint
	xchg	bx, bx		;magic breakpoint	
	nop
	
	
	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_GP 		; Mensaje
	call print
	xchg	bx, bx	


	irq_13_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	
	iret

; IRQ 14 - #PF - FAULT 		 -> Page FAULT
irq_14_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_PF 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_14_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	
	iret

; IRQ 16 - #MF - FAULT		 -> Error en coma flotante y FPU
irq_16_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_MF 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_16_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 17 - #AC - FAULT 		 -> Comprobacion de alineamiento
irq_17_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_AC 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_17_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 18 - #MC - ABORT		 -> Comprobacion de maquina
irq_18_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_MC 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_18_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret

; IRQ 19 - #XF - FAULT 		 -> Coma flotante SIMD
irq_19_handler:

	;pushad

	push GRIS 			; Color
	push 0x05 			; Fila
	push 0x00 			; Columna
	push texto_XF 		; Mensaje
	call print

	

	; Salvamos Excepcion

	irq_19_handler_end:
	pop eax ;pop color 
	pop eax	;pop fila
	pop eax;pop columna
	pop eax;pop mensaje
	;popad
	iret
	
; IRQ 32 - Interrupcion de Timer ###############################
timerValue: 	db "00", 0

 
timer_handler:
	xchg	bx, bx		;magic breakpoint
	nop
	xchg	bx, bx		;magic breakpoint	
	nop
	nop
	
		
	mov dx, word [timerValue] 		; Obtenemos valor de cunta [little endian]

	inc dh									; Incrementamos unidades...
	cmp dh, '9'								; Verificamos si paso de 9...
	jle update_screenValue 						; Si no paso continua...

	mov dh, '0'								; Seteamos las unidades en 0
	inc dl									; Incrementamos decenas...
	cmp dl, '9'								; Verificamos si paso de 9...
	jle update_screenValue 						; Si no paso continua...

	mov dl, '0' 							; Seteamos decenas en 0

	update_screenValue: 							; Actualizamos pantalla

		mov word [timerValue], dx 	; Actualizamos valor de cuenta

		push VERDE 							; Color
		push 0x08 							; Fila
		push 0x00 							; Columna
		push timerValue 	     			; Mensaje
		call print
		pop eax
		pop eax
		pop eax
		pop eax
		
	
	iret 								

; ### END TIMER HANDLER #################################################


; IRQ 33 - Interrupcion de teclado ######################################
irq_keyb_handler:

	;pushad 				; Salvamos registros
	xchg	bx, bx		;magic breakpoint
	nop
	nop
	xchg	bx, bx		;magic breakpoint	
		
	xor eax, eax 		; Inicializamos registros
	xor edx, edx 		

	in 	al , TECLADO	; Leemos teclado y queda guardado en EAX
    mov edx, TECLA_LEIDA; Cargamos el puntero de la variable TECLA_LEIDA

	xchg	bx, bx		;magic breakpoint	

	
    cmp eax, 0x81 		; Checkeamos Breakcode...
    jle keyb_handler_end
    mov al , 0x00 		; Si es un breakcode... no hay tecla nueva...

	keyb_handler_end:
	;push eax 	; Almacenamos la tecla en la pila actualizada... 
	mov al, 0x20
    out 0x20, al 		; Habilitamos nuevamente el PIC para interrumpir
     ;popad				; Recuperamos registros
	iret 				; Retornamos al programa...

; ### END KEYBOARD HANDLER ##############################################

; IRQ 34 - IRQ Mal configurada para generar GP (CS MAL CONFIGURADO)
IRQ_MAL_CONFIGURADA:
	
	iret
