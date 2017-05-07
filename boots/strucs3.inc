;///////////////////////////////////////////////////////////////////////////////
;Definicion de las estructuras principales del programa
;Autores: Alejandro Furfaro y Mariano Cerdeiro
;

;///////////////////////////////////////////////////////////////////////////////
;Descriptor de segmento de codigo y datos
;
struc	descriptor
	limit_lo_word   resw 1	;límite del segmento 0-15
	base_lo_word    resw 1	;Dirección base A0 - A15
	base_hi_byte    resb 1	;Dirección base A16 - A23
	access_rights   resb 1	;derechos de acceso al segmento
	limi_hi_byte    resb 1	;Límite parte alta 16-19 + derechos de acceso
	base_mh_byte    resb 1	;Dirección Base A24 - A31
endstruc


;///////////////////////////////////////////////////////////////////////////////
;Descriptor de segmento de Sistema
;
struc	system_descriptor
	Offset0_15	resw 1	;Offset del punto de entrada 0-15.
	Selector	resw 1	;Selector de segmento de código del punto de entrada
	Param		resb 1	;Solo para call gates. De otro modo no se usa
	access		resb 1	;derechos de acceso al segmento
	Offset16_31	resw 1	;Offset del punto de entrada 16-31
endstruc


;///////////////////////////////////////////////////////////////////////////////
;Descriptor de Segmento Estado de Tarea (TSS)
;
struc tss_struc
        .reg_PTL       resw 1
                       resw 1
        .reg_ESP0      resd 1
        .reg_SS0       resw 1
                       resw 1
        .reg_ESP1      resd 1
        .reg_SS1       resw 1
                       resw 1
        .reg_ESP2      resd 1
        .reg_SS2       resw 1
		       resw 1
        .reg_CR3       resd 1
        .reg_EIP       resd 1
        .reg_EFLAGS    resd 1
        .reg_EAX       resd 1
        .reg_ECX       resd 1
        .reg_EDX       resd 1
        .reg_EBX       resd 1
        .reg_ESP       resd 1
        .reg_EBP       resd 1
        .reg_ESI       resd 1
        .reg_EDI       resd 1
        .reg_ES        resw 1
                       resw 1
        .reg_CS        resw 1
                       resw 1
        .reg_SS        resw 1
                       resw 1
        .reg_DS        resw 1
                       resw 1
        .reg_FS        resw 1
                       resw 1
        .reg_GS        resw 1
                       resw 1
        .reg_LDT       resw 1
        .reg_T         resw 1
        .reg_IOMAP     resw 1
        .IOMAP         resd 1
endstruc

;///////////////////////////////////////////////////////////////////////////////
;Para instanciar se emplea la sintaxis que figura en este comentario.
;Solo inicializamos los miembros de la estructura que llevaran un valor distinto
;de cero. Es decir solo aquellos que necesitamos en un valor especifico y
;diferentes de cero cuando la tarea se inicia por primera vez.
;Nasm por default inicializara en 0 todo miembro de la estructura que no se haya
;inicializado en la instanciacion de la misma.
;TSS_sup_struc istruc tss_struc
;        at tss_struc.reg_EIP,           dd tarea_sup
;        at tss_struc.reg_EFLAGS,        dd 202h
;        at tss_struc.reg_ESP,           dd pila_sup
;        at tss_struc.reg_CS,            dw code_sel
;        at tss_struc.reg_SS,            dw data_sel
;        at tss_struc.IOMAP,             dd 0ffffffffh
;iend

