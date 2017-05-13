section     .text
;global      _start                    ;debe declararse para el linker
extern msg, msg2, msg3
extern len, len2, len3
extern _imprime

;_start:              ;le dice al linker el punto de inicio
	; cargar en algun lado (puede ser la pila)
	; puntero a mensaje y long
	; y  llamar a rutina
	push	msg
	push	len
	call	_imprime	;no hace falta balancear la pila al retorno, lo hace _imprime
	push	msg2
	push	len2
	call	_imprime
	push	msg3
	push	len3
	call	_imprime
	;invoca puerta de llamada del kernel
	mov		eax,1
	int		0x80	;salida al S.O.
;-------------------------------------------------------------------
;END

