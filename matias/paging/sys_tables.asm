[BITS 32]
SECTION 	.data		

global		MI_gdtr
global		MI_idtr
global 		MI_GDT
global		MI_IDT
global		Desc_Dato32b	
global		Desc_codigo32b
global		Desc_Stack32b
global		 vector_end

global		handler_vector
global		idt_vector

INTERRUPCION32bits 	equ 10001110b					; INTERRUPCION32bits de 32 bits
EXCEPCION32bits 	equ 10001111b					; EXCEPCION32bits de 32 bits

;
;Los handler estan definidos en el init_vect.asm
EXTERN 	irq_0_handler  	;IRQ 0
EXTERN 	irq_1_handler  	;IRQ 1
EXTERN 	irq_2_handler  	;IRQ 2
EXTERN 	irq_3_handler  	;IRQ 3
EXTERN 	irq_4_handler  	;IRQ 4
EXTERN 	irq_5_handler  	;IRQ 5
EXTERN 	irq_6_handler  	;IRQ 6
EXTERN 	irq_7_handler  	;IRQ 7
EXTERN 	irq_8_handler  	;IRQ 8
EXTERN 	irq_9_handler  	;IRQ 9
EXTERN 	irq_10_handler 	;IRQ 10
EXTERN 	irq_11_handler 	;IRQ 11
EXTERN 	irq_12_handler 	;IRQ 12
EXTERN 	irq_13_handler 	;IRQ 13
EXTERN 	irq_14_handler 	;IRQ 14
EXTERN 	irq_16_handler  ;IRQ 16
EXTERN 	irq_17_handler  ;IRQ 17
EXTERN 	irq_18_handler  ;IRQ 18
EXTERN 	irq_19_handler  ;IRQ 19
extern	timer_handler	; handler del timer
EXTERN 	irq_keyb_handler	; handler del teclado





SECTION 	.data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       Global Descriptor Table ( GDT) MIA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Tabla de datos
ALIGN 8
; Descriptor nulo. No inicializar
MI_GDT:   dw 0                    ; Limite 15:0
        dw 0                    ; Base 15:0
        db 0                    ; Base 23:16
        db 0                    ; Byte de derechos de acceso
        db 0                    ; Limite 19:16, flags
        db 0                    ; Base 31:24
 
Desc_codigo32b equ $-MI_GDT
        dw 0FFFFh 			; limit low
		dw 0x0 				; base low
		db 0x0 				; base middle
		db 10011010b 			;   P=1, DPL=00,S=1, Type 1010, 
		db 11001111b 			 ; G=1, B=1, L=0,AVL=0 , limite 1111
		db 0x00 				; base high
		
Desc_Dato32b equ $-MI_GDT
		dw 0xffff               ; Limite 15:0
        dw 0x0                    ; Base 15:0
        db 0x0                    ; Base 23:16
        db 10010010b               ; P=1, DPL=00,S=1, Type 0010, 
        db 11001111b               ; G=1, B=1, L=0,AVL=0 , limite 1111
        db 0x00                    ; Base 31:24

Desc_Stack32b equ $-MI_GDT     	; la pila va de 0x ffff 0000 a 0x ffff ffff
		dw 0xfff0               ; Limite 15:0
        dw 0x0000                  ; Base 15:0
        db 0xff                    ; Base 23:16
   ;     db 10010110b               ; P=1, DPL=00,S=1, Type 0110 Read/Write, expand-down
        db 10010010b               ; P=1, DPL=00,S=1, Type 0010 Read/Write
       ; db 01000000b               ; G=0, B=1, L=0,AVL=0 , limite 0000
        db 11000000b               ; G=1, B=1, L=0,AVL=0 , limite 0000
        db 0xff                    ; Base 31:24

Desc_Interrupcion32b equ $-MI_GDT
        dw 0FFFFh 			; limit low
		dw 0x0 				; base low
		db 0x0 				; base middle
		db 10011010b 			;   P=1, DPL=00,S=1, Type 1010, 
		db 11001111b 			 ; G=1, B=1, L=0,AVL=0 , limite 1111
		db 0x00 				; base high

        
GDT_Lim equ $-MI_GDT

MI_gdtr:
	dw GDT_Lim    	;Limite
	dd MI_GDT				     ;Base


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      Interrupt Descriptor Table ( IDT) MIA
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tabla de datos
ALIGN 8

MI_IDT:		 
		 
irq_0:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_1:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_2:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	INTERRUPCION32bits			; P=1, DPL=00, TIPO=1110
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 		

irq_3:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_4:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_5:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_6:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_7:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_8:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_9:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_10:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_11:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_12:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_13:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_14:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_15:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						

irq_16:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_17:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_18:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_19:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db 	EXCEPCION32bits 			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina

irq_20:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_21:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_22:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_23:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_24:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_25:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_26:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_27:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_28:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_29:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_30:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						
irq_31:
		dw  0x0000						; IRQ Reservada
		dw 	0x0000						
		db 	0x00						
		db 	0x00						
		dw 	0x0000						


irq_32:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db EXCEPCION32bits
		;db 	INTERRUPCION32bits			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 

irq_33:
		dw  0x0000						; Offset IRQ (00:15) - A completar por rutina
		dw 	Desc_Interrupcion32b					; CS de IRQ	
		db 	0x00						; NULL Byte
		db EXCEPCION32bits
		;db 	INTERRUPCION32bits			; P=1, DPL=00, TIPO=1111
		dw 	0x0000						; Offset IRQ (16:31) - A completar por rutina 
		
	;times 256-34 db 0x00
IDT_LENGTH  equ 	$-MI_IDT

MI_idtr:
	dw 		IDT_LENGTH-1
	dd 		MI_IDT

;-------------------------------------------
; + Handler vector
; + USO: Todas las direcciones de cada handler deben estar definidas en este
; 		 vector de 256 posiciones (una por handler). Para las posiciones que contengan
; 		 una direccion valida, esta direccion sera insertada en su correspondiente
; 		 descriptor en la IDT. Sera realizado por la rutina "init_interrupt_vector".
;-------------------------------------------
vector_end equ 0xCAFECAFE 	; END IRQ VECTOR COOKIE

handler_vector:
dd 	irq_0_handler  	;IRQ 0
dd 	irq_1_handler  	;IRQ 1
dd 	irq_2_handler  	;IRQ 2
dd 	irq_3_handler  	;IRQ 3
dd 	irq_4_handler  	;IRQ 4
dd 	irq_5_handler  	;IRQ 5
dd 	irq_6_handler  	;IRQ 6
dd 	irq_7_handler  	;IRQ 7
dd 	irq_8_handler  	;IRQ 8
dd 	irq_9_handler  	;IRQ 9
dd 	irq_10_handler 	;IRQ 10
dd 	irq_11_handler 	;IRQ 11
dd 	irq_12_handler 	;IRQ 12
dd 	irq_13_handler 	;IRQ 13
dd 	irq_14_handler 	;IRQ 14
dd 	0xFFFFFFFF  	;IRQ 15
dd 	irq_16_handler  ;IRQ 16
dd 	irq_17_handler  ;IRQ 17
dd 	irq_18_handler  ;IRQ 18
dd 	irq_19_handler  ;IRQ 19
dd 	0xFFFFFFFF  	;IRQ 20
dd 	0xFFFFFFFF  	;IRQ 21
dd 	0xFFFFFFFF  	;IRQ 22
dd 	0xFFFFFFFF  	;IRQ 23
dd 	0xFFFFFFFF  	;IRQ 24
dd 	0xFFFFFFFF  	;IRQ 25
dd 	0xFFFFFFFF  	;IRQ 26
dd 	0xFFFFFFFF  	;IRQ 27
dd 	0xFFFFFFFF  	;IRQ 28
dd 	0xFFFFFFFF  	;IRQ 29
dd 	0xFFFFFFFF  	;IRQ 30
dd 	0xFFFFFFFF  	;IRQ 31
dd  timer_handler	;IRQ 32 timer
dd	irq_keyb_handler ;IRQ 33 teclado
dd 	vector_end

idt_vector:
dd 	irq_0
dd 	irq_1
dd 	irq_2
dd 	irq_3
dd 	irq_4
dd 	irq_5
dd 	irq_6
dd 	irq_7
dd 	irq_8
dd 	irq_9
dd 	irq_10
dd 	irq_11
dd 	irq_12
dd 	irq_13
dd 	irq_14
dd 	irq_15
dd 	irq_16
dd 	irq_17
dd 	irq_18
dd 	irq_19
dd 	irq_20
dd 	irq_21
dd 	irq_22
dd 	irq_23
dd 	irq_24
dd 	irq_25
dd 	irq_26
dd 	irq_27
dd 	irq_28
dd 	irq_29 	
dd 	irq_30
dd 	irq_31
dd 	irq_32
dd 	irq_33
dd 	vector_end
;---------------------------------------------------
	
