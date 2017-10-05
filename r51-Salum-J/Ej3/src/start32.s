%define EXCEPTION_DE_NUMBER 0
%define EXCEPTION_DB_NUMBER 1
%define EXCEPTION_NMI_NUMBER 2
%define EXCEPTION_BP_NUMBER 3
%define EXCEPTION_OF_NUMBER 4
%define EXCEPTION_BR_NUMBER 5
%define EXCEPTION_UD_NUMBER 6
%define EXCEPTION_NM_NUMBER 7
%define EXCEPTION_DF_NUMBER 8
%define EXCEPTION_TS_NUMBER 10
%define EXCEPTION_NP_NUMBER 11
%define EXCEPTION_SS_NUMBER 12
%define EXCEPTION_GP_NUMBER 13
%define EXCEPTION_PF_NUMBER 14
%define EXCEPTION_MF_NUMBER 16
%define EXCEPTION_AC_NUMBER 17
%define EXCEPTION_MC_NUMBER 18
%define EXCEPTION_XM_NUMBER 19
%define EXCEPTION_VE_NUMBER 20
%define INT_0_NUMBER 32
%define INT_1_NUMBER 33
%define INT_2_NUMBER 34
%define INT_3_NUMBER 35
%define INT_4_NUMBER 36
%define INT_5_NUMBER 37
%define INT_6_NUMBER 38
%define INT_7_NUMBER 39
%define INT_8_NUMBER 40
%define INT_9_NUMBER 41
%define INT_10_NUMBER 42
%define INT_11_NUMBER 43
%define INT_12_NUMBER 44
%define INT_13_NUMBER 45
%define INT_14_NUMBER 46
%define INT_15_NUMBER 47

SECTION .start32 progbits

USE32									; Codigo de 32bits

EXTERN	__STACK_END_32
EXTERN	__STACK_SIZE_32
EXTERN	CS_SEL_32
EXTERN	DS_SEL
EXTERN	kernel32_init

EXTERN	__IDT_ENTRIES
EXTERN	__IDT_START
EXTERN	__init_idt
EXTERN	__set_idt_entry
EXTERN	__fast_memcpy
EXTERN	___idt_ctrlrs_size
EXTERN	___idt_ctrlrs_vma_st
EXTERN	___idt_ctrlrs_lma_st

EXTERN	EXCEPTION_DE
EXTERN	EXCEPTION_DB
EXTERN	EXCEPTION_NMI
EXTERN	EXCEPTION_BP
EXTERN	EXCEPTION_OF
EXTERN	EXCEPTION_BR
EXTERN	EXCEPTION_UD
EXTERN	EXCEPTION_NM
EXTERN	EXCEPTION_DF
EXTERN	EXCEPTION_TS
EXTERN	EXCEPTION_NP
EXTERN	EXCEPTION_SS
EXTERN	EXCEPTION_GP
EXTERN	EXCEPTION_PF
EXTERN	EXCEPTION_MF
EXTERN	EXCEPTION_AC
EXTERN	EXCEPTION_MC
EXTERN	EXCEPTION_XM
EXTERN	EXCEPTION_VE
EXTERN	INT_0
EXTERN	INT_1
EXTERN	INT_2
EXTERN	INT_3
EXTERN	INT_4
EXTERN	INT_5
EXTERN	INT_6
EXTERN	INT_7
EXTERN	INT_8
EXTERN	INT_9
EXTERN	INT_10
EXTERN	INT_11
EXTERN	INT_12
EXTERN	INT_13
EXTERN	INT_14
EXTERN	INT_15

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
	xor	eax,eax
	mov	ecx,__STACK_SIZE_32

	; Cargo la pila con ceros
	.stack_init:
		push	eax
		loop	.stack_init
	mov	esp,__STACK_END_32					; Ubico el stack pointer

	; Inicializacion de IDT
	push	ebp
	mov	ebp,esp
	push	word (__IDT_ENTRIES - 1)
	push	dword __IDT_START
	call	__init_idt
	mov	esp, ebp
	pop	ebp
   
	; Muevo los handlers de interrupcion de ROM a RAM ya que los voy a utilizar repetidamente
	push	ebp
	mov	ebp,esp
	push	___idt_ctrlrs_size
	push	___idt_ctrlrs_vma_st
	push	___idt_ctrlrs_lma_st
	call	__fast_memcpy
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	jmp	inicializo_excepciones					; Inicializo las entradas

fin_inic_excepciones:
	jmp	CS_SEL_32:kernel32_init					; Salto al programa en modo protegido ya inicializado el procesador y los registros correctamente

finalizo_programa:
	hlt
	jmp 	finalizo_programa


inicializo_excepciones:

;TASK GATE: OCURRE UN CAMBIO DE TAREA
;31             24              16               8               0
;+-------------------------------+-+---+-+-+-+-+-+---------------+
;|            RESERVED           |P|DPL|0|0|1|0|1|    RESERVED   |	P: Segment Present Flag, 0->Not In Memory, 1->In Memory
;|                               | | | |         |               |	DPL: Privilege Level, 00->Kernel, 01->OS Services, 10->OS Services, 11->Applications
;+--------------+-+---+-+---+----------+-+-+-+-+-+--+-+-+--------+	
;|     TSS SEGMENT SELECTOR      |            RESERVED           |
;|                               |                               |
;+-------------------------------+-------------------------------+

;INTERRUPT/TRAP GATE: INTERRUPT GATE LIMPIA EL IF FLAG PARA NO ATENDER OTRAS INT, LA OTRA NO
;31             24              16               8               0
;+-------------------------------+-+---+-+-+-+-+-+-+-+-+---------+
;|         OFFSET(31-16)         |P|DPL|0|D|1|1|X|0|0|0| RESERVED|	D: Size Of Gate, 0->16 bits, 1->32 bits
;|                               | | | |               |         |	X: 0->Interrupt Gate, 1->Trap Gate
;+--------------+-+---+-+---+----------+-+-+-+-+-+--+-+-+--------+
;|       SEGMENT SELECTOR        |         OFFSET(15-0)          |
;|                               |                               |
;+-------------------------------+-------------------------------+

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_DE
	;push	CS_SEL_32
	push	EXCEPTION_DE_NUMBER					; Division por 0
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_DB
	push	CS_SEL_32
	push	EXCEPTION_DB_NUMBER					; Excepcion de debug
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_NMI
	push	CS_SEL_32
	push	EXCEPTION_NMI_NUMBER					; Generada por un pin externo
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_BP
	push	CS_SEL_32
	push	EXCEPTION_BP_NUMBER					; Ejecucion de instruccion de breakpoint
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_OF
	push	CS_SEL_32
	push	EXCEPTION_OF_NUMBER					; Overflow cuando se ejecutaba instruccion INTO
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_BR
	push	CS_SEL_32
	push	EXCEPTION_BR_NUMBER					; Rango excedido
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_UD
	push	CS_SEL_32
	push	EXCEPTION_UD_NUMBER					; Opcode invalido
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_NM
	push	CS_SEL_32
	push	EXCEPTION_NM_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_DF
	push	CS_SEL_32
	push	EXCEPTION_DF_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa
	
	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_TS
	push	CS_SEL_32
	push	EXCEPTION_TS_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_NP
	push	CS_SEL_32
	push	EXCEPTION_NP_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_SS
	push	CS_SEL_32
	push	EXCEPTION_SS_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_GP
	push	CS_SEL_32
	push	EXCEPTION_GP_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_PF
	push	CS_SEL_32
	push	EXCEPTION_PF_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_MF
	push	CS_SEL_32
	push	EXCEPTION_MF_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_AC
	push	CS_SEL_32
	push	EXCEPTION_AC_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_MC
	push	CS_SEL_32
	push	EXCEPTION_MC_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_XM
	push	CS_SEL_32
	push	EXCEPTION_XM_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_VE
	push	CS_SEL_32
	push	EXCEPTION_VE_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_0
	push	CS_SEL_32
	push	INT_0_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_1
	push	CS_SEL_32
	push	INT_1_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_2
	push	CS_SEL_32
	push	INT_2_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_3
	push	CS_SEL_32
	push	INT_3_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_4
	push	CS_SEL_32
	push	INT_4_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_5
	push	CS_SEL_32
	push	INT_5_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_6
	push	CS_SEL_32
	push	INT_6_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_7
	push	CS_SEL_32
	push	INT_7_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_8
	push	CS_SEL_32
	push	INT_8_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_9
	push	CS_SEL_32
	push	INT_9_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_10
	push	CS_SEL_32
	push	INT_10_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_11
	push	CS_SEL_32
	push	INT_11_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_12
	push	CS_SEL_32
	push	INT_12_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_13
	push	CS_SEL_32
	push	INT_13_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_14
	push	CS_SEL_32
	push	INT_14_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_15
	push	CS_SEL_32
	push	INT_15_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax, 1							; Analizo el valor de retorno (1 Exito -1 Fallo)
	jne	finalizo_programa

	jmp	fin_inic_excepciones
