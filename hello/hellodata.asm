


section .mensajes2

global	msg
global	msg2
global	len
global	len2

msg     db  0xa,'Hola mundo en asm linux!1',0xa,0xa		;mensaje
len     equ $ - msg  
msg2     db  0xa,'Hola mundo en asm linux!2',0xa,0xa		;mensaje
len2     equ $ - msg2  

