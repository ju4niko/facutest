%define BOOT_SEG 0xF0000

SECTION .sys_tables progbits

EXTERN	__handlers_32h
EXTERN	__handlers_32_01l

; Hago visible las direcciones importantes para manejar los distintos datos
GLOBAL	GDTR
GLOBAL	CS_SEL_16
GLOBAL	CS_SEL_32
GLOBAL	DS_SEL

GDT:
	NULL_SEL	equ		$-GDT
		dq		0x0					; Descriptor nulo (reservado)

	CS_SEL_16	equ		$-GDT				; Descriptor de segmento de codigo de 16bits
		dw		0xffff					; limite (16bits)
		dw		0x0000					; base (16bits)
		db		0xff					; base (8bits)
		db		0x99					; P|DPL[1:0]|S|Type[3:0] (8bits)
		db		0x40					; G|D/B|L|AVL|limite (8bits)
		db		0xff					; base (8bits)
		; Direccion de Base = 0xffff0000
		; Limite = 0x0ffff
		; Granularidad = NO
		; Tamanio de Operandos = 32 bits
		; Habilitar uso del Sistema = NO
		; Nivel de Privilegio = 0
		; Segmento de 64bits = NO
		; Tipo de Descriptor = Codigo
		; Segmento Presente = SI

	CS_SEL_32	equ		$-GDT				; Descriptor de segmento de codigo de 32bits
		dw 		0xffff
		dw 		0x0000
		db 		0x00
		db 		0x99
		db 		0xcf
		db 		0x00
		; Direccion de Base = 0x00000000
		; Limite = 0xfffff
		; Granularidad = SI
		; Tamanio de Operandos = 32 bits
		; Habilitar uso del Sistema = NO
		; Nivel de Privilegio = 0
		; Segmento de 64bits = NO
		; Tipo de Descriptor = Codigo
		; Segmento Presente = SI

	DS_SEL		equ		$-GDT				; Descriptor de segmento de dato
		dw		0xffff
		dw		0x0000
		db		0x00
		db		0x92
		db		0xcf
		db		0x00
		; Direccion de Base = 0x00000000
		; Limite = 0xfffff
		; Granularidad = SI
		; Tamanio de Operandos = 32 bits
		; Habilitar uso del Sistema = NO
		; Nivel de Privilegio = 0
		; Segmento de 64bits = NO
		; Tipo de Descriptor = Dato
		; Segmento Presente = SI

	GDT_LENGHT	equ		$-GDT				; Indice del largo de la tabla

GDTR:
	dw 		GDT_LENGHT-1
	dd 		BOOT_SEG+GDT
