/*archivos de entrada, hay que enumerarlos uno por INPUT*/
INPUT(hello.o)	
INPUT(hellodata.o)
INPUT(hellodata2.o)
INPUT(hello-rutinas.o)

/*salida, en este caso un exe elf64*/
OUTPUT(hello)	

/* auto explicativo, ver objdump -i para listado de formatos
en este caso de ejemplo para 64 bit ELF y arquitectura i386 de 64 bits*/
OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)

/*indico el punto de entrada acorde al simbolo global en el fuente que
tiene la primera instruccion a ejecutar*/
ENTRY(_comienzo)

/*secciones del ejecutable, ubicacion en mapa de memoria donde se van a cargar */
SECTIONS
{
/* . es el origen de generacion de direcciones para seccion*/
	. = 0x400080;		/*valor tomado de un objdump de un elf64 de ejemplo*/	
	.rutinas : 
	{ 
		hello-rutinas.o(.text)
	} 
	.datos : 
	{ 
		*(.mensajes)
		hellodata.o	(.mensajes2)
	}	
	.inicio : 
	{ 
		hello.o(.text) 
	} 
}

