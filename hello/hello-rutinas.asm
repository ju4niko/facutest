section .text
global _imprime
_imprime:
;pila:
;      |        | 
;      |  rip   |<----- rsp
;      |  len   |	rsp +8
;      |  msg   |	rsp+16
;      +--------+

	pop		rax		;recupero rip
	pop		rdx		;longitud del mensaje
	pop		rcx		;puntero al mensaje
	push	rax		;lo pongo para el retorno
	
    mov     ebx,1                               ;file descriptor (stdout)
    mov     eax,4                               ;nro de syscall (sys_write)
    int     0x80                                ;invoca puerta de llamada del kernel
    
	ret
	
