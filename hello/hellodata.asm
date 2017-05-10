


section     .data

global	msg
global	msg2
global	msg3
global	len
global	len2
global	len3

msg     db  0xa,'Hola mundo en asm linux!1',0xa,0xa		;mensaje
len     equ $ - msg  
msg2     db  0xa,'Hola mundo en asm linux!2',0xa,0xa		;mensaje
len2     equ $ - msg2  
msg3     db  0xa,'Hola mundo en asm linux!3',0xa,0xa		;mensaje
len3     equ $ - msg3  
