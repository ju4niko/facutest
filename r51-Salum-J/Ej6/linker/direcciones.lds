/**/
__PAG_PDE		=	0x00001000;
__PAG_PTE		=	0x00002000;
__PAG_CODIGO		=	0x10000000;
__PAG_COD_16		=	__PAG_CODIGO;
__PAG_COD_32		=	__PAG_COD_16 + ___inic16_size;
__PAG_COD_UTL		=	__PAG_COD_32 + ___inic32_size;
__PAG_COD_KERNEL	=	0x10401000;
__PAG_COD_VIDEO		=	0x10802000;
__PAG_DATOS_R		=	0x10C03000;
__PAG_DATOS_RW		=	0x11004000;
__PAG_DATOS_BINARIO	=	0x11405000;
__PAG_HANDLERS		=	0x11806000;
__PAG_PILA		=	0x11C07000;
__PAG_RESET		=	0x12008000;
__SALTO_COD32		=	__PAG_COD_KERNEL + kernel32_init - ___kernel_vma;		/* Debido a que antes de la etiqueta de inicio tengo variables */

__DIREC_VIDEO		=	0xB8000;

__STACK_START_16	=	0x9000;
__STACK_END_16		=	0xFFFF;
__STACK_START_32	=	__PAG_PILA;
__STACK_END_32		=	__PAG_PILA + 0xFFF;
__STACK_SIZE_32		=	((__STACK_END_32 - __STACK_START_32) / 4);

__IDT_START		=	__PAG_DATOS_R + ___gdt_size*8;
__IDT_ENTRIES		=	256;                        					/* Valor humano contando desde 1 */
__IDT_SIZE		=	(__IDT_ENTRIES * 8);

MEMORY
{
	ram (!x) : ORIGIN = 0x00000000, LENGTH = 0xFFFF0000					/* Memoria RAM */
	rom32 (rx) : ORIGIN = 0xFFFF0000, LENGTH = 0xD000					/* Memoria ROM dedicada a 32 bits */
	rom16 (rx) : ORIGIN = 0x0000D000, LENGTH = 0x2FFF					/* Memoria ROM dedicada a 16 bits */
}

SECTIONS
{
	/* Seccion donde comienza el codigo del procesador en 32 bits */
	___kernel_vma = 0xFFFF0000;
	.codigo_kernel32 ___kernel_vma :
	AT( ___kernel_vma )
	{*(.kernel32);} > rom32
	___kernel_lma = LOADADDR(.codigo_kernel32);  
	___kernel_size = SIZEOF(.codigo_kernel32);

	/* Seccion donde se encuentran los handlers de idt */
	___idt_vma = __PAG_HANDLERS;
	.codigo_idt ___idt_vma :
	AT ( ___kernel_lma + ___kernel_size ) 
	{ *(.idt_ctrlrs_32_asm); } > ram
	___idt_lma = LOADADDR(.codigo_kernel32) + SIZEOF(.codigo_kernel32);
	___idt_size = SIZEOF(.codigo_idt);

	/* Seccion donde comienza la inicializacion del procesador en 32 bits */
	___inic32_vma = 0xD000;
	.codigo32 ___inic32_vma :
	AT( 0xFFFFD000 )
	{*(.start32);} > rom16
	___inic32_lma = LOADADDR(.codigo32);
	___inic32_size = SIZEOF(.codigo32);

	/* Seccion donde comienza la inicializacion del procesador en 16 bits */
	___inic16_vma = 0xDF00;
	.codigo16 ___inic16_vma :
	AT( 0xFFFFDF00 )
	{*(.start16);} > rom16
	___inic16_lma = LOADADDR(.codigo16);  
	___inic16_size = SIZEOF(.codigo16);

	/* Seccion donde comienza la inicializacion del controlador de video */
	___video_vma = 0xE000;
	.video ___video_vma :
	AT( 0xFFFFE000 )
	{*(.video);} > rom16
	___video_lma = LOADADDR(.video);  
	___video_size = SIZEOF(.video);

	/* Seccion con las funciones del pic */
	___utils16_vma = 0xF400;
	.utils16 ___utils16_vma :
	AT( 0xFFFFF400 )
	{*(.utils16);} > rom16
	___utils16_lma = LOADADDR(.utils16);  
	___utils16_size = SIZEOF(.utils16);
    
	/* Seccion donde se encuentran las tablas de dato */
	___gdt_vma = 0xF500;
	.tablas ___gdt_vma :
	AT( 0xFFFFF500 )
	{*(.sys_tables*);} > rom16
	___gdt_lma = LOADADDR(.tablas);  
	___gdt_size = SIZEOF(.tablas);

	/* Seccion donde inicia el procesador despues del reset */
	___reset_vma = 0xFFF0;
	.codigo_reset ___reset_vma :
	AT( 0xFFFFFFF0 )
	{*(.reset);} > rom16
	___reset_lma = LOADADDR(.codigo_reset);  
	___reset_size = SIZEOF(.codigo_reset);

	/* Lleno de nop la memoria que no se utiliza desde el final de la seccion reset (si no el bochs funciona mal) */
	.fill_rom16 :	
	{ FILL(0x90);
	. = ORIGIN(rom16) + LENGTH(rom16)-1;
	BYTE(0x90);
	} > rom16

	.end_rom16 0xFFFF:
	AT( 0xFFFFFFFF )
	{ BYTE(0x90); }
}

