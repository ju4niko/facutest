section     .text
global      _start                              ;debe declararse para el linker

_start:                                         ;le dice al linker el punto de inicio

	; DS queda apuntando por defecto al segmento con los datos
    mov     edx,len                             ;longitud del mensaje
    mov     ecx,msg                             ;puntero al mensaje
    mov     ebx,1                               ;file descriptor (stdout)
    mov     eax,4                               ;nro de syscall (sys_write)
    push	rax
    push	rbx
    int     0x80                                ;invoca puerta de llamada del kernel

	pop		rbx
	pop		rax
    mov     edx,len2                             ;longitud del mensaje
    mov     ecx,msg2                             ;puntero al mensaje
    push	rax
    push	rbx
    int     0x80                                ;invoca puerta de llamada del kernel

	pop		rbx
	pop		rax
    mov     edx,len3                             ;longitud del mensaje
    mov     ecx,msg3                             ;puntero al mensaje
    int     0x80                                ;invoca puerta de llamada del kernel

	mov		eax,1
	int		0x80
	

section     .data
msg     db  0xa,'Hola mundo en asm linux!1',0xa,0xa		;mensaje
len     equ $ - msg  
msg2     db  0xa,'Hola mundo en asm linux!2',0xa,0xa		;mensaje
len2     equ $ - msg2  
msg3     db  0xa,'Hola mundo en asm linux!3',0xa,0xa		;mensaje
len3     equ $ - msg3  
