/** 
	\file  init32.c	
	\version 01.00
	\brief Definicion de funciones de inicializacion del procesador en 32b

	\author Christian Nigri <cnigri@utn.edu.ar>
	\date    18/04/2017
*/

#include "header/x86_types.h"
#include "header/sys_types.h"

/***************************************************************************//**
*
* @fn         __fast_memcpy
*
* @brief      Esta funcion copia length double words desde dst a src. 
*             No se raliza validacion de las regiones de memoria.
*             En caso de exito retorna EXITO o ERROR_DEFECTO en cualquier otra 
*             circunstancia
*
* @param [in] src puntero tipo double word. Especifica la direccion de origen.
*
* @param [in] dst puntero tipo double word. Especifica la direccion de destino.
*
* @param [in] length tipo double word. Especifica el numero de double wors a copiar.
*
* @return     tipo byte indicando si falla o no.
*
******************************************************************************/
__attribute__(( section(".start32"))) byte __fast_memcpy(const dword *src, dword *dst, dword length)
{

   byte status = ERROR_DEFECTO;

   if(length > 0)
   {
      
      while(length)
      {
         length--;
         *dst++ = *src++;
      }
      status = EXITO;   
   }

   return(status);
}
