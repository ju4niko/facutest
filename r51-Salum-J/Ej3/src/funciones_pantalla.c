#define	BUFFER_VIDEO		0x000B8000
#define	TOTAL_FILAS		200
#define	TOTAL_COLUMNAS		80
#define	TOTAL_PANTALLA		BUFFER_VIDEO+TOTAL_FILAS*TOTAL_COLUMNAS
#define	ERROR_COLUMNA		-1
#define	ERROR_FILA		-1
#define	NO_ENTRA_PALABRA	-1
#define	EXITO			0
#define	NULL			0

/*===============================================================================
 * \function			clrsrc
 * \brief			Limpio pantalla
 * \param			Vacio
 * \return 			Vacio
 *===============================================================================
 */

__attribute__((section(".kernel32"))) void clrsrc( void )
{
	unsigned int *direccion_actual = (unsigned int *) BUFFER_VIDEO;

	while( direccion_actual != (unsigned int *) TOTAL_PANTALLA ){
		*direccion_actual = 0;							// Borro caracter pantalla
		direccion_actual++;
		*direccion_actual = 0;							// Color del caracter
		direccion_actual++;
	}
}


/*===============================================================================
 * \function			print
 * \brief			Escribo string en pantalla
 * \param			char *string_ptr:	puntero al string a escribir
 *				char columna:		columna donde comenzar a escribir
 *				char fila:		fila donde comenzar a escribir
 *				char color:		color del string
 * \return 			ERROR_COLUMNA:		numero de columna mayor al de pantalla
 *				ERROR_FILA:		numero de fila mayor al de pantalla
 *				NO_ENTRA_PALABRA:	no se logro imprimir todos los caracteres
 *				EXITO:			se escribio correctamente el string
 *===============================================================================
 */

__attribute__((section(".kernel32"))) char print( char *string_ptr, char columna, char fila, char color )
{
	unsigned int *direccion_actual = (unsigned int *) BUFFER_VIDEO;
	
	if( columna >= TOTAL_COLUMNAS )							// Si el numero de columna esta mal, error
		return ERROR_COLUMNA;

	if( fila >= TOTAL_FILAS )							// Si el numero de fila esta mal, error
		return ERROR_FILA;

	// Me ubico en la direccion a comenzar a escribir
	direccion_actual += columna*2;
	direccion_actual += fila*TOTAL_COLUMNAS;

	while( ( string_ptr != NULL ) && ( direccion_actual < (unsigned int *) TOTAL_PANTALLA ) ){	
		*direccion_actual = *string_ptr;					// Imprimo caracter en pantalla
		string_ptr++;

		direccion_actual++;
		*direccion_actual = color;						// Color del catacter
		direccion_actual++;
	}
	
	if( string_ptr == NULL )							// Si se pudo escribir toda la palabra (no desbordo la pantalla) devuelvo OK
		return EXITO;

	return NO_ENTRA_PALABRA;							// Desbordo la palabra en pantalla
}

