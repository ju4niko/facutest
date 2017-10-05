__STACK_START_16 = 0x9000;
__STACK_END_16 = 0xffff;
__STACK_START_32 = 0x00070000;
__STACK_END_32 = 0x0007ffff;
__STACK_SIZE_32 = ((__STACK_END_32 - __STACK_START_32) / 4);

MEMORY
{
	rom32 (rx) : ORIGIN = 0xFFFF0000, LENGTH = 0xF000					/* Memoria ROM dedicada a 32 bits */
	rom16 (rx) : ORIGIN = 0xF000, LENGTH = 0xFFF						/* Memoria ROM dedicada a 16 bits */
}

SECTIONS
{
	/* Seccion donde comienza el codigo del procesador en 32 bits */
	vma_kernel32 = 0xFFFF0000;
	.codigo_kernel32 vma_kernel32 :
	AT( 0xFFFF0000 )
	{*(.kernel32);} > rom32

	/* Seccion donde comienza la inicializacion del procesador en 32 bits */
	vma_inic32 = 0xF000;
	.codigo32 vma_inic32 :
	AT( 0xFFFFF000 )
	{*(.start32);} > rom16

	/* Seccion donde comienza la inicializacion del procesador en 16 bits */
	vma_inic16 = 0xF800;
	.codigo16 vma_inic16 :
	AT( 0xFFFFF800 )
	{*(.start16);} > rom16
    
	/* Seccion donde se encuentran las tablas de dato */
	vma_datos = 0xFD00;
	.tablas vma_datos :
	AT( 0xFFFFFD00 )
	{*(.sys_tables*);} > rom16

	/* Seccion donde inicia el procesador despues del reset */
	vma_reset = 0xFFF0;
	.codigo_reset vma_reset :
	AT( 0xFFFFFFF0 )
	{*(.reset);} > rom16

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

