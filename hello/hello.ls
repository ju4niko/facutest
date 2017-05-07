INPUT(hello.o)
SECTIONS
{
  . = 0x4000b0;
  .text : { *(.text) }
  . = 0x6000f0;
  .data : { *(.data) }
  .bss : { *(.bss) }
}
