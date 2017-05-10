INPUT(hello.o, hellodata.o)	/*archivos de entrada*/
OUTPUT(hello)	/*salida, en este caso un exe elf64*/
SECTIONS
{
  . = 0x4000b0;		/*valor tomado de un objdump de un elf64*/
  .text : { *(.text) }
  . = 0x6000f0;		/*valor tomado de un objdump de un elf64*/
  .data : { *(.data) }
  .bss : { *(.bss) }
}

