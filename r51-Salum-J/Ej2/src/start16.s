SECTION .start16 progbits

USE16									; Codigo de 16bits

EXTERN	__STACK_START_16
EXTERN	__STACK_END_16
EXTERN	start32_launcher						; Etiqueta externa donde comienza la inicializacion en 32bits
EXTERN	GDTR								; Direccion del registro de la tabla de descriptores globales
EXTERN	CS_SEL_16							; Direccion del selector de segmento de codigo de 16bits

GLOBAL	start16_inic							; Hago visible la etiqueta para que se pueda utilizar en el reset

start16_inic:
	; Igualo ds a cs para asegurarme que no esten desfazado
	mov		ax,cs						
	mov		ds,ax

	lgdt [GDTR]							; Cargo la gdt

	; Inicializacion de la pila
	mov		ax,__STACK_START_16
	mov 		ss,ax						; Cargo en el segmento de stack el inicio de la pila de 16bits
	mov 		sp,__STACK_END_16				; Cargo en el stack pointer el final de la pila de 16bits

	; Paso a modo protegido al colocar 1 en el bit0 del cr0
	mov		eax,cr0
	or		eax,0x01
	mov		cr0,eax

	; Limpio Pipeline
	jmp		flush_prefetch_queue

flush_prefetch_queue:
	; Cargo la pila como cuando aparece una int, de esta manera entro definitivamente en modo protegido con datos y direcciones de 32bits
	mov		ax,start32_launcher				; Cargo en el acumulador A la etiqueta donde se encuentra el codigo en 32bits
	pushf								; Cargo los FLAGS en la pila
	push		word CS_SEL_16					; Cargo el selector de segmento de codigo de 16bits en la pila
	push		ax
	iret								; Al igual que al volver de una int, vuelvo a cargar los registros con los valores del stack, por esto salto a start32_launcher
