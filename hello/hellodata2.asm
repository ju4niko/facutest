section .mensajes

global	msg3
global	len3

msg3     db  0xa,'Hola mundo en asm linux!3',0xa,0xa		;mensaje
len3     equ $ - msg3  
