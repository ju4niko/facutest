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
%define PAGINA4K 0
%define PAGINA4M 1

SECTION .start32 progbits

USE32									; Codigo de 32bits

EXTERN	__STACK_END_32
EXTERN	__STACK_SIZE_32
EXTERN	CS_SEL_32
EXTERN	DS_SEL
EXTERN	kernel32_init

EXTERN	__init_idt
EXTERN	__set_idt_entry
EXTERN	__fast_memcpy
EXTERN	__inic_pde_pte
EXTERN	__set_ptree32

EXTERN	__IDT_START
EXTERN	__IDT_SIZE
EXTERN	__PAG_PDE
EXTERN	__PAG_PTE
EXTERN	__PAG_CODIGO
EXTERN	__PAG_COD_16
EXTERN	__PAG_COD_32
EXTERN	__PAG_COD_UTL
EXTERN	___inic16_size
EXTERN	___inic16_lma
EXTERN	___inic32_size
EXTERN	___inic32_lma
EXTERN	___utils16_size
EXTERN	___utils16_lma
EXTERN	__PAG_COD_KERNEL
EXTERN	___kernel_size
EXTERN	___kernel_lma
EXTERN	__PAG_COD_VIDEO
EXTERN	___video_size
EXTERN	___video_lma
EXTERN	__PAG_DATOS_R
EXTERN	___gdt_size
EXTERN	___gdt_lma
EXTERN	__PAG_DATOS_RW
EXTERN	__PAG_HANDLERS
EXTERN	___idt_size
EXTERN	___idt_lma
EXTERN	__PAG_DATOS_BINARIO
EXTERN	__PAG_PILA
EXTERN	__PAG_RESET
EXTERN	___reset_size
EXTERN	___reset_lma
EXTERN	__SALTO_COD32
EXTERN	__DIREC_VIDEO

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

gdtr		dq	0x0
idtr		dq	0x0

start32_launcher:
	; Inicializo selectores de dato
	mov	ax,DS_SEL
	mov	ds,ax
	mov	es,ax
	mov 	gs,ax
	mov 	fs,ax

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
	push	dword (__IDT_SIZE - 8)
	push	dword __IDT_START
	call	__init_idt
	mov	esp, ebp
	pop	ebp

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

inicializo_excepciones:							; Inicializo las entradas
	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_DE
	push	CS_SEL_32
	push	EXCEPTION_DE_NUMBER					; Division por 0
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_DB
	push	CS_SEL_32
	push	EXCEPTION_DB_NUMBER					; Excepcion de debug
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_NMI
	push	CS_SEL_32
	push	EXCEPTION_NMI_NUMBER					; Generada por un pin externo
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_BP
	push	CS_SEL_32
	push	EXCEPTION_BP_NUMBER					; Ejecucion de instruccion de breakpoint
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_OF
	push	CS_SEL_32
	push	EXCEPTION_OF_NUMBER					; Overflow cuando se ejecutaba instruccion INTO
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_BR
	push	CS_SEL_32
	push	EXCEPTION_BR_NUMBER					; Rango excedido
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_UD
	push	CS_SEL_32
	push	EXCEPTION_UD_NUMBER					; Opcode invalido
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_NM
	push	CS_SEL_32
	push	EXCEPTION_NM_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_DF
	push	CS_SEL_32
	push	EXCEPTION_DF_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa
	
	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_TS
	push	CS_SEL_32
	push	EXCEPTION_TS_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_NP
	push	CS_SEL_32
	push	EXCEPTION_NP_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_SS
	push	CS_SEL_32
	push	EXCEPTION_SS_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_GP
	push	CS_SEL_32
	push	EXCEPTION_GP_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_PF
	push	CS_SEL_32
	push	EXCEPTION_PF_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_MF
	push	CS_SEL_32
	push	EXCEPTION_MF_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_AC
	push	CS_SEL_32
	push	EXCEPTION_AC_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_MC
	push	CS_SEL_32
	push	EXCEPTION_MC_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_XM
	push	CS_SEL_32
	push	EXCEPTION_XM_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8f							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	EXCEPTION_VE
	push	CS_SEL_32
	push	EXCEPTION_VE_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_0
	push	CS_SEL_32
	push	INT_0_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_1
	push	CS_SEL_32
	push	INT_1_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_2
	push	CS_SEL_32
	push	INT_2_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_3
	push	CS_SEL_32
	push	INT_3_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_4
	push	CS_SEL_32
	push	INT_4_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_5
	push	CS_SEL_32
	push	INT_5_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_6
	push	CS_SEL_32
	push	INT_6_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_7
	push	CS_SEL_32
	push	INT_7_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_8
	push	CS_SEL_32
	push	INT_8_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_9
	push	CS_SEL_32
	push	INT_9_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_10
	push	CS_SEL_32
	push	INT_10_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_11
	push	CS_SEL_32
	push	INT_11_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_12
	push	CS_SEL_32
	push	INT_12_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_13
	push	CS_SEL_32
	push	INT_13_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_14
	push	CS_SEL_32
	push	INT_14_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	push	ebp
	mov	ebp,esp
	push	0x8e							; 0b10001111->Segmento presente, Privilegio de Kernel, Selector de 32bits, Trap Gate
	push	INT_15
	push	CS_SEL_32
	push	INT_15_NUMBER
	call	__set_idt_entry
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	jmp	fin_inic_excepciones

finalizo_programa:
	hlt
	jmp 	finalizo_programa

fin_inic_excepciones:	
	; Copio secciones de memoria a paginas
	; Copio RESET
	push	ebp
	mov	ebp,esp
	push	___reset_size
	push	__PAG_RESET
	push	___reset_lma
	call	__fast_memcpy
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Copio START16
	push	ebp
	mov	ebp,esp
	push	___inic16_size
	push	__PAG_COD_16
	push	___inic16_lma
	call	__fast_memcpy
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Copio START32
	push	ebp
	mov	ebp,esp
	push	___inic32_size
	push	__PAG_COD_32
	push	___inic32_lma
	call	__fast_memcpy
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Copio UTILS16
	push	ebp
	mov	ebp,esp
	push	___utils16_size
	push	__PAG_COD_UTL
	push	___utils16_lma
	call	__fast_memcpy
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Copio KERNEL32
	push	ebp
	mov	ebp,esp
	push	___kernel_size
	push	__PAG_COD_KERNEL
	push	___kernel_lma
	call	__fast_memcpy
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Copio VIDEO
	push	ebp
	mov	ebp,esp
	push	___video_size
	push	__PAG_COD_VIDEO
	push	___video_lma
	call	__fast_memcpy
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Copio SysTables
	push	ebp
	mov	ebp,esp
	push	___gdt_size
	push	__PAG_DATOS_R
	push	___gdt_lma
	call	__fast_memcpy
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa
   
	; Copio los handlers de interrupcion
	push	ebp
	mov	ebp,esp
	push	___idt_size
	push	__PAG_HANDLERS
	push	___idt_lma
	call	__fast_memcpy
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Inicializo el directorio y la tabla de paginas
	push	ebp
	mov	ebp,esp
	push	__PAG_PTE
	push	__PAG_PDE
	call	__inic_pde_pte
	leave

	; Cargo directorio y la tabla de paginas
	; Cargo pagina de codigo
	push	ebp
	mov	ebp,esp
	push	0x003							; Atributos de pagina
	push	__PAG_CODIGO						; Direccion lineal
	push	__PAG_CODIGO						; Direccion fisica
	push	0x03							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo directorio y la tabla de paginas
	; Cargo pagina de codigo
	push	ebp
	mov	ebp,esp
	push	0x003							; Atributos de pagina
	push	__PAG_COD_KERNEL					; Direccion lineal
	push	__PAG_COD_KERNEL					; Direccion fisica
	push	0x03							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo directorio y la tabla de paginas
	; Cargo pagina de codigo
	push	ebp
	mov	ebp,esp
	push	0x003							; Atributos de pagina
	push	__PAG_COD_VIDEO						; Direccion lineal
	push	__PAG_COD_VIDEO						; Direccion fisica
	push	0x03							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo directorio y la tabla de paginas
	; Cargo pagina de codigo
	push	ebp
	mov	ebp,esp
	push	0x003							; Atributos de pagina
	push	__DIREC_VIDEO						; Direccion lineal
	push	__DIREC_VIDEO						; Direccion fisica
	push	0x03							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo pagina de datos de solo lectura
	push	ebp
	mov	ebp,esp
	push	0x001							; Atributos de pagina
	push	__PAG_DATOS_R						; Direccion lineal
	push	__PAG_DATOS_R						; Direccion fisica
	push	0x01							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo pagina de datos de lectura y escritura
	push	ebp
	mov	ebp,esp
	push	0x003							; Atributos de pagina
	push	__PAG_DATOS_RW						; Direccion lineal
	push	__PAG_DATOS_RW						; Direccion fisica
	push	0x03							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo pagina de manejadores de interrupciones
	push	ebp
	mov	ebp,esp
	push	0x003							; Atributos de pagina
	push	__PAG_HANDLERS						; Direccion lineal
	push	__PAG_HANDLERS						; Direccion fisica
	push	0x03							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo pagina de binario
	push	ebp
	mov	ebp,esp
	push	0x003							; Atributos de pagina
	push	__PAG_DATOS_BINARIO					; Direccion lineal
	push	__PAG_DATOS_BINARIO					; Direccion fisica
	push	0x03							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo pagina de pila
	push	ebp
	mov	ebp,esp
	push	0x003							; Atributos de pagina
	push	__PAG_PILA						; Direccion lineal
	push	__PAG_PILA						; Direccion fisica
	push	0x03							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo pagina de reset
	push	ebp
	mov	ebp,esp
	push	0x001							; Atributos de pagina
	push	__PAG_RESET						; Direccion lineal
	push	__PAG_RESET						; Direccion fisica
	push	0x01							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo pagina de codigo actual para poder activar paginacion
	push	ebp
	mov	ebp,esp
	push	0x001							; Atributos de pagina
	push	___inic32_lma						; Direccion lineal
	push	___inic32_lma						; Direccion fisica
	push	0x01							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo pagina con codigo de kernel que esta en rom para saltar ahi
	push	ebp
	mov	ebp,esp
	push	0x001							; Atributos de pagina
	push	___kernel_lma						; Direccion lineal
	push	___kernel_lma						; Direccion fisica
	push	0x01							; Atributos de directorio
	push	__PAG_PTE						; Direccion tabla de pagina
	push	__PAG_PDE						; Direccion directorio de pagina (CR3)
	call	__set_ptree32
	leave
	cmp	eax,0							; Analizo el valor de retorno (0 Exito 1 Fallo)
	jne	finalizo_programa

	; Cargo la gdtr con la nueva direccion
	sgdt	[gdtr]							; Cargo el valor previo a la variable
	mov	dword [gdtr+2],__PAG_DATOS_R				; Modifico la direccion base a la nueva (los primeros dos byte es el largo)
	lgdt	[gdtr]							; Cargo la nueva gdtr

	; Cargo la idtr con la nueva direccion
	sidt	[idtr]							; Cargo el valor previo a la variable
	mov	dword [idtr+2],__IDT_START				; Modifico la direccion base a la nueva (los primeros dos byte es el largo)
	lidt	[idtr]							; Cargo la nueva idtr
	
	; Cargo CR3 con la memoria fisica
	mov	eax,__PAG_PDE
	;or	eax,0x08						; Cargo atributos, PWT = 1
	mov	cr3,eax

	; Paginacion de 32 bit
	;mov	eax,cr4
	;or	eax,0x00300010						; PAE = 0, PSE = 1 (hab pag de 4K y 4M), PGE = 0, PCIDE = 0, SMEP = 1 (no puedo fetchear instruc de usuario cuando el soft esta en 										supervisor), SMAP = 1 (No puedo acceder a datos de usuario en modo supervisor), PKE = 0
	;mov	cr4,eax
			
	; Habilito la paginacion
	mov	eax,cr0
	or	eax,0x80010000						; PG = 1, WP = 1
	mov	cr0,eax
			
	; Habilito interrupciones en el PIC
	; PIC 1
	mov al,0x00
	out 0x21,al
	; PIC 2
	mov al,0x00
	out 0xA1,al
			
	; Habilito interrupciones
	sti

	jmp	CS_SEL_32:__SALTO_COD32					; Salto al codigo de aplicacion
