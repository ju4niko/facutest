/** 
	\file  x86_types.h	
	\version 01.00
   \brief Biblioteca de declaraciones y definiciones propias del procesador x86.

   \author Christian Nigri <cnigri@frba.utn.edu.ar>
   \date    01/02/2012
*/

#ifndef _ASM_X86_PROCESSOR_TYPES_H
   #define _ASM_X86_PROCESSOR_TYPES_H  0

#include "sys_types.h"

/** \def PD_ATTR */
#define PD_ATTR   (0x1 << 4)  ///<Atributo Presente para el descriptor.
/** \def GATE32 */
#define GATE32    (0x1 << 3)  ///<Atributo Tamaño de 32b para el descriptor.
/** \def DPL0 */
#define DPL0      (0x0)       ///<Nivel de privilegio 0 para el descriptor.
/** \def DPL1 */
#define DPL1      (0x1 << 5)  ///<Nivel de privilegio 1 para el descriptor.
/** \def DPL2 */
#define DPL2      (0x1 << 6)  ///<Nivel de privilegio 2 para el descriptor.
/** \def DPL3 */
#define DPL3      (DPL1+DPL2) ///<Nivel de privilegio 3 para el descriptor.
/** \def INT_GATE */
#define INT_GATE  (0x0E)      ///<Descriptor tipo interrupcion.
/** \def INT_GATE */
#define EXC_GATE  (0x0F)      ///<Descriptor tipo excepcion.

/**
 \struct desc_idt32_t
 \brief Tipo utilizado para definir descriptores de IDT para el modo 32b. Tamaño 8 bytes
*/
typedef struct __attribute__((packed)){
    word    offset_l;   ///< Parte baja del desplazamiento    
    word    segment;	///< Selector    
    byte    zero ;      ///< Reservado  
    byte    config ;    ///< Configuracion del descriptor 
    word    offset_h;   ///< Parte alta del desplazamiento   
}desc_idt32_t;


/**
 \struct idtr_t
 \brief Tipo utilizado para definir IDTR.
*/
typedef struct __attribute__((packed)){
    word      limit;    ///< Tamaño de la IDT   
   dword      base;     ///< Direccion base de la IDT 
}idtr_t;

#endif /*__ASM_X86_PROCESSOR_TYPES_H  0*/
