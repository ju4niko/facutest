/*archivos de entrada, hay que enumerarlos uno por INPUT*/
INPUT(hello.o)	
INPUT(hellodata.o)
INPUT(hellodata2.o)
INPUT(hello-rutinas.o)

/*salida, en este caso un exe elf64*/
OUTPUT(hello)	

/*secciones del ejecutable, ubicacion en mapa de memoria donde se van a cargar */
SECTIONS
{
	/* . es el origen de generacion de direcciones para seccion*/
	. = 0x400080;		/*valor tomado de un objdump de un elf64*/
	.text : 
	{ 
		hello.o(.text) 
	} 
	
	/*en este ejemplo enumero una a una las input data sections
	. = 0x4000bd;*/
	
	.datos : 
	{ 
		*(.mensajes)
		hellodata.o	(.mensajes2)
	}	

	.rutinas : 
	{ 
		hello-rutinas.o(.text)
	} 
	
}

