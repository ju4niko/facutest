/*archivos de entrada, hay que enumerarlos uno por INPUT*/
INPUT(hello.o)	
INPUT(hellodata.o)
INPUT(hellodata2.o)

/*salida, en este caso un exe elf64*/
OUTPUT(hello)	

/*secciones del ejecutable, ubicacion en mapa de memoria donde se van a cargar */
SECTIONS
{
	/* . es el origen de generacion de direcciones para seccion*/
	. = 0x4000b0;		/*valor tomado de un objdump de un elf64*/
	
	/* 
		.codigo es el nombre en el mapa del linker de output section, del otro lado (:) estan 
		los nombres de las input sections 
		en este caso junta todas las .text pero hay una sola
		el * (wildcard) reemplaza todos los nombres de archivos .o 
		podria definir tambien por ej. asi:
	
		.codigo = { hello.o (.text) }  
		
		que se interpretaria como meter en la seccionn de salida .codigo
		la seccion .text que esta en hello.o 
	*/
	
	.codigo : 
	{ 
		*(.text) 
	} 
	
	/*
		luego para las secciones de datos es lo mismo, por ej:
		. = 0x6000f0;		valor tomado de un objdump de un elf64
		pero esto generaria una imagen ejecutable muy grande
		si no defino una posicion en memoria en particular, va a
		continuacion.
	*/
	
	/*en este ejemplo enumero una a una las input data sections*/
	.datos : 
	{ 
		*			(.mensajes)
		hellodata.o	(.mensajes2)
		
	}	
	
	/*las sections tipo bss quedan a continuacion, aca no se usan
	si quisiese ubicarla en algun punto del mapa de memoria de programa
	en particular tendria que incluir el . = 0x...... */
	
	.bss : 
	{ 
		*(.bss) 
	}
}

