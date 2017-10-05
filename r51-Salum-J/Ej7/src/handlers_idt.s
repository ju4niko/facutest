SECTION  .idt_ctrlrs_32_asm progbits

USE32

; Etiquetas
GLOBAL	EXCEPTION_DE							; Division por 0
GLOBAL	EXCEPTION_DB							; Excepcion de debug
GLOBAL	EXCEPTION_NMI							; Generada por un pin externo
GLOBAL	EXCEPTION_BP							; Ejecucion de instruccion de breakpoint
GLOBAL	EXCEPTION_OF							; Overflow cuando se ejecutaba instruccion INTO
GLOBAL	EXCEPTION_BR							; Rango excedido
GLOBAL	EXCEPTION_UD							; Opcode invalido
GLOBAL	EXCEPTION_NM
GLOBAL	EXCEPTION_DF
GLOBAL	EXCEPTION_CO
GLOBAL	EXCEPTION_TS
GLOBAL	EXCEPTION_NP
GLOBAL	EXCEPTION_SS
GLOBAL	EXCEPTION_GP
GLOBAL	EXCEPTION_PF
GLOBAL	EXCEPTION_MF
GLOBAL	EXCEPTION_AC
GLOBAL	EXCEPTION_MC
GLOBAL	EXCEPTION_XM
GLOBAL	EXCEPTION_VE
GLOBAL	INT_0
GLOBAL	INT_1
GLOBAL	INT_2
GLOBAL	INT_3
GLOBAL	INT_4
GLOBAL	INT_5
GLOBAL	INT_6
GLOBAL	INT_7
GLOBAL	INT_8
GLOBAL	INT_9
GLOBAL	INT_10
GLOBAL	INT_11
GLOBAL	INT_12
GLOBAL	INT_13
GLOBAL	INT_14
GLOBAL	INT_15

; Funciones
EXTERN	print
EXTERN	print_contador

; Variables
ex_num0		db	'Excepcion generada: 0'
ex_num1 	db	'Excepcion generada: 1'
ex_num2 	db	'Excepcion generada: 2'
ex_num3 	db	'Excepcion generada: 3'
ex_num4 	db	'Excepcion generada: 4'
ex_num5 	db	'Excepcion generada: 5'
ex_num6 	db	'Excepcion generada: 6'
ex_num7 	db	'Excepcion generada: 7'
ex_num8 	db	'Excepcion generada: 8'
ex_num10 	db	'Excepcion generada: 10'
ex_num11	db	'Excepcion generada: 11'
ex_num12 	db	'Excepcion generada: 12'
ex_num13 	db	'Excepcion generada: 13'
ex_num14	db	'Excepcion generada: 14'
ex_num16	db	'Excepcion generada: 16'
ex_num17	db	'Excepcion generada: 17'
ex_num18	db	'Excepcion generada: 18'
ex_num19	db	'Excepcion generada: 19'
ex_num20	db	'Excepcion generada: 20'
color		db	0x0
color_contador	db	0x05
contador	dd	0x00000000
mensaje_esc	db	'Tecla ESC presionada'


dummy_entry:
	push	eax
	hlt
			
	mov	al,0x20
	out	0x20,al

	pop	eax
	iretd
FIN:
	hlt
	jmp	FIN


HANDLERS_IDT_START	equ	$

align 32
EXCEPTION_DE		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num0
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_DB		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num1
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_NMI		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num2
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_BP 		equ 	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num3
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_OF		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num4
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_BR		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num5
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_UD		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num6
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_NM		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num7
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_DF		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num8
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_TS		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num10
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_NP		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num11
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_SS		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num12
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_GP		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num13
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_PF		equ	$
			xchg	bx,bx
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num14
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_MF		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num16
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_AC		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num17
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_MC		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num18
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_XM		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num19
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
EXCEPTION_VE		equ	$
			xchg	bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	ex_num20
			call	print
			mov	esp,ebp
			pop	ebp
			hlt
			iret
			
align 32
INT_0			equ	$					; Interrupcion de timer
			; Imprimo contador en pantalla
			mov	eax,dword [contador]
			add	eax,1
			mov	[contador],eax
			cmp	eax,32767				; Maximo valor positivo del word
			je	contador_reset
			jmp	imprimo_contador
contador_reset:
			mov	[contador],word 0x0000
imprimo_contador:
			push	ebp
			mov	ebp,esp
			push	color_contador
			push	0x00
			push	0x40
			push	contador
			call	print_contador
			mov	esp,ebp
			pop	ebp
			cmp	eax,0					; Analizo el valor de retorno (0 Exito -1 Fallo)
			;jne	mensaje_error
			jmp	fin_INT
mensaje_error:
			jmp	fin_INT
fin_INT:
			; Limpio las interrupciones del PIC
			push	eax
			mov	al,0x20
			out	0x20,al
			pop	eax
			iret
			
align 32
INT_1			equ	$					; Interrupcion de teclado
			xchg	bx,bx
			in	al,60h					; Leo el teclado
			test	al,0x80					; Analizo si es break code o make code
			js	fin_INT					; Si es break code finalizo interrupcion ya que es cuando suelto la tecla

make_code:								; Tomo el valor de la tecla y voy a la excepcion correspondiente
			cmp 	al,0x12					; Tecla 'E'
			je	genero_de
			cmp	al,0x16					; Tecla 'U'
			je	genero_ud
			cmp	al,0x20					; Tecla 'D'
			je	genero_df
			cmp	al,0x22					; Tecla 'G'
			je	genero_gp
			cmp	al,0x19					; Tecla 'P'
			je	genero_pf
			cmp	al,0x01					; Tecla 'P'
			je	tecla_esc
			jmp	fin_INT					; En caso de no se algunas de las teclas de excepcion
genero_de:
			; Divide Error Exception
			xchg	bx,bx
			mov	ax,0x01
			mov	bx,0x00
			div	bx
			jmp	fin_INT
genero_ud:
			; Invalid Opcode Exception
			xchg	bx,bx
			ud2
			jmp	fin_INT
genero_df:
			; Double Fault Exception
			xchg	bx,bx
			jmp	fin_INT
genero_gp:
			; General Protection Exception
			xchg	bx,bx
			mov	ax,0x00
			mov	cs,ax
			jmp	fin_INT
genero_pf:
			; Page-Fault Exception
			xchg bx,bx
			jmp	fin_INT

tecla_esc:
			; Imprimo mensaje de tecla ESC
			xchg bx,bx
			push	ebp
			mov	ebp,esp
			push	color
			push	0x00
			push	0x00
			push	mensaje_esc
			call	print
			mov	esp,ebp
			pop	ebp
			jmp	fin_INT
			
align 32
INT_2			equ	$
			jmp	dummy_entry
			
align 32
INT_3			equ	$
			jmp	dummy_entry
			
align 32
INT_4			equ	$
			jmp	dummy_entry
			
align 32
INT_5			equ	$
			jmp	dummy_entry
			
align 32
INT_6			equ	$
			jmp	dummy_entry
			
align 32
INT_7			equ	$
			jmp	dummy_entry
			
align 32
INT_8			equ	$
			jmp	dummy_entry
			
align 32
INT_9			equ	$
			jmp	dummy_entry
			
align 32
INT_10			equ	$
			jmp	dummy_entry
			
align 32
INT_11			equ	$
			jmp	dummy_entry
			
align 32
INT_12			equ	$
			jmp	dummy_entry
			
align 32
INT_13			equ	$
			jmp	dummy_entry
			
align 32
INT_14			equ	$
			jmp	dummy_entry
			
align 32
INT_15			equ	$
			jmp	dummy_entry
			
EXCEPTION_DUMMY		equ	$-HANDLERS_IDT_START
