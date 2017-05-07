
;------- EQU's y definiciones del sistema---------------------------
CONSTANTE EQU 1
;----------------------------------------------

[ORG KERNEL_MEMORY] ;debe estar definida en el Makefie

[BITS 16]
 
%ifndef KERNEL_MEMORY
        %error "la direccion del kernel no esta definida"
%endif

start:
	jmp Inicio


;---------------Tablas y estructuras de datos del sistema -------------------------------

; Tabla de datos
ALIGN 8

datos_alineados:	;por ej para una GDT....
	db 0   ;



;------------Fin de espacio de tablas y estructuras del sistema
	
Inicio:

	cli

	lgdt [valor_gdtr]	;cargo valor de tabla en gdtr (base+limite, 48 bits)
	lidt [valor_idtr]	;cargo valor de table en idtr (base+limite, 48 bits)

	

	mov eax,cr0		;seteo el bit 0 (PM) de CR0
	or al,1
	mov cr0,eax

	jmp 08:ModoProt


ModoProt:
