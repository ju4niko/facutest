global cleansc
global print
global print2
global Timer_Config
%define 	VGA_RAM			0xB8000

%define 	STACK_STRING 		[ebp+8]
%define 	STACK_COLUMNA 		[ebp+12]
%define 	STACK_FILA 			[ebp+16]
%define 	STACK_COLOR 		[ebp+20]

SECTION .text
[BITS 32]




cleansc:
	push 	ebp
	mov 	ebp,esp
	mov		edi, 0xB8000 
	mov		esi, " "
	mov		ecx, 2000			;cantidad de caracteres totales en pantalla

	clear:
		mov 		[edi],esi
		cmp		ecx, 0	;me fijo si ya recorri todos los caracteres
		jz		fin_clrscr
		add		edi, 2
	loop 	clear

	fin_clrscr:
	pop ebp
	ret
end_clrscr:



;*******************************************************************************
; prototipo:		void print(char* string, char columna, char fila, char color)
; descripcion:		escribe en pantalla
;*******************************************************************************
;print_pos= VGA_RAM+(2*CANT_COLUMNA)*COLUMNA+2*FILA
print:
      push ebp
      mov ebp,esp
      mov esi,STACK_STRING	;mensaje
      mov eax,STACK_FILA 	;eax=fila
      mov edx,80*2			;edx=160
      mul edx			  	;eax=edx*fila
      mov edx,STACK_COLUMNA ;edx=columna
      sal edx,1				;edx=columna*2
      add eax,edx			;eax=80*2*columna+fila*2
      add eax,VGA_RAM		;eax=VGA_RAM+25*columna+fila
      mov edi,eax			;edi=VGA_RAM+25*columna+fila
      mov eax,STACK_COLOR	;color
      mov ah,al 			;muevo el color a la parte alta de ah
      
      imprimir:
		  mov	al,[esi]
		  cmp	al,0
		  jz 	fin_imprimir
		  mov 	[edi], ax	;ax=color,letra
		  add 	edi,2
		  inc 	esi
	  loop imprimir
	  
      fin_imprimir:
	  pop ebp
	  ret
end_print:




;++++++++++++++++++++
; con pila valanceada
;++++++++++++++++++++

print2:

	pop		ecx		;ecx=recupero eip
	pop		esi		;esi=el mensaje
	pop		edx		;eax=columnas
	pop		eax		;edx=filas
	pop 	ebx		;ebx=color
	push	ecx		;recupero eip para regresar

	mov ecx,80*2	;ecx=160
	mul ecx			;eax=ecx*columnas=160*columnas
	
	sal edx,1			; ebx=filas*2
	add eax,ebx 		;eax=160*columnas+filas*2
	add eax,VGA_RAM		;eax=VGA_RAM+160*columna+fila
	mov edi,eax			;edi=VGA_RAM+160*columna+fila
	mov eax,ebx			;eax=color
	mov ah,al 			;muevo el color a la parte alta de ah

	imprimir2:
		  mov	al,[esi]
		  cmp	al,0
		  jz 	fin_imprimir
		  mov 	[edi], ax	;ax=color,letra
		  add 	edi,2
		  inc 	esi
	loop imprimir2

	fin_imprimir2:
	
	  ret
end_print2:
	


;********************************************************************************
; Prototipo: void Timer_Config (void);
; Uso:		 Funcion que configura el timer.
; Detalles : Oscilador interno a 1.193182 MHz.
;http://www.brokenthorn.com/Resources/OSDevPit.html
;********************************************************************************
; ## PORTS
TIMER_CH0_DATA 	equ 0x40 				; Channel 0 data port (read/write)
TIMER_CH1_DATA 	equ 0x41    			; Channel 1 data port (read/write)
TIMER_CH2_DATA 	equ 0x42    			; Channel 2 data port (read/write)
TIMER_CMD_ADDR 	equ 0x43         		; Mode/Command register (write only)

; ## CONFIGS
RATE_GENEATOR 	equ 00110100b 			; Timer con base de tiempo
SQWV_GENEATOR 	equ 00110110b 			; Onda cuadrada

; ## Frecuency
SYS_FREQUENCY 	equ 1193182 			; Frec in Hz
DESIRED_FREC 	equ 100 				; Desired Frecuency in Hz
FREC_DIV 		equ SYS_FREQUENCY/DESIRED_FREC

Timer_Config:

	push 	ebp
	mov 	ebp, esp 					; Acomodamos stack

	push 	eax 						; Salvamos registros
	xor 	eax, eax 					; Inicializamos registros

	Timer_Config_begin:

   ; COUNT = input hz / frequency
 
	mov	dx, 1193180 / 100	; 100hz, or 10 milliseconds
 
	; FIRST send the command word to the PIT. Sets binary counting,
	; Mode 3, Read or Load LSB first then MSB, Channel 0
 
	mov	al, 110110b
	out	0x43, al
 
	; Now we can write to channel 0. Because we set the "Load LSB first then MSB" bit, that is
	; the way we send it
 
	mov	ax, dx
	out	0x40, al	;LSB
	xchg	ah, al
	out	0x40, al	;MSB

 	Timer_Config_end:

    	pop eax
    	pop ebp
	ret

