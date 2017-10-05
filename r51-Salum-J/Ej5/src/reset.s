SECTION	.reset

USE16									; Codigo de 16bits

EXTERN	start16_inic							; Etiqueta externa donde comienza la inicializacion en 16bits

reset_inic:
	cli								; Limpio flag de interrupciones (deshabilito interrupciones por hardware)
	cld								; Limpio flag de direcciones
	jmp	start16_inic						; Salto al comienzo de codigo de 16bits con el procesador en modo real
