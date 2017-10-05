global cleansc
global print
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
   ;  xchg	bx, bx														;magic breakpoint

	  pop ebp
	  ret
end_print:




	


;********************************************************************************
; Prototipo: void Timer_Config (void);
; Uso:		 Funcion que configura el timer.
;	http://www.brokenthorn.com/Resources/OSDevPit.html
;********************************************************************************

Timer_Config:

	push 	ebp
	mov 	ebp, esp 					; Acomodamos stack

	pushad 	 						; Salvamos registros
	xor 	eax, eax 					; Inicializamos registros
	xor 	edx,edx 					; Inicializamos registros
	; xchg	bx, bx														;magic breakpoint	
	Timer_Config_begin:

		 
			mov al,0x34 ; 00110100 configuro para cargarlo en 2 partes y auto triger interrupcion
			out 0x43,al
			; 1193=0x04a9  esta es la cuenta
			mov al,0xA9
			out 0x40,al
		
			mov al,0x04
			out 0x40,al

 	Timer_Config_end:

    	popad
    	pop ebp
   	ret

