section .text
global _imprime
_imprime:
;pila:
;      |        | 
;      |  rip   |<----- rsp
;      |   cs   |
;      |  len   |
;      |  msg   |
;      +--------+
    mov		rdx,  [rsp+8]                       ;longitud del mensaje
    mov		rcx,  [rsp+16]                       ;puntero al mensaje
    mov     ebx,1                               ;file descriptor (stdout)
    mov     eax,4                               ;nro de syscall (sys_write)
    int     0x80                                ;invoca puerta de llamada del kernel
    
	ret
	
