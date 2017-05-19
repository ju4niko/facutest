
SECTIONS
{
	. = 0xFFFFFFF0; 							/* location counter = VMA */
	.reset_vector : 							/* Reset vector */ 
	  AT ( 0xFFFFFFF0 )							/* LMA al origen del binario */
		{ *(.reset_vector) __reset_vector = . ; }

	. = 0xFFFF0000; 							/* location counter = VMA */
	.init :										/* seccion de salida */
	  AT ( 0xFFFF0000 )							/* Desplazo para alinear a 0x100 el offset de init16.asm */
		{ *(.init); }
		
	.tables 0x00100000 : 
	  AT ( LOADADDR(.init) + SIZEOF(.init) )
		{ __sys_tables_LMA = LOADADDR(.tables);
		__sys_tables_start = . ; *(.sys_tables*);
		__sys_tables_end = . ;}

	. = 0x00110000; 							/* location counter = VMA */
	__main_start = . ;							/* VMA del punto de entrada 1Mb */
	.main :										/* seccion de salida */
	  AT ( LOADADDR(.tables) + SIZEOF(.tables) )
		{ __main_LMA = LOADADDR(.main);			/* LMA del codigo de 32 */
		*(.main); *(.text); __main_end = . ; }
		
	.mdata 0x00120000 : 	
	  AT ( LOADADDR(.main) + SIZEOF(.main) )
		{ __mdata_LMA = LOADADDR(.mdata);
		  __mdata_start = . ; *(.data);
		  __mdata_end = . ; }
	
	__datos_no_iniciali_inicio = .;
	 
	.bss 0x00130000 :
		{ __bss_start = . ; *(.bss) *(COMMON); 
		*(.dat_no_inic*); __bss_end = . ;}
  

}
