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
typedef struct __attribute__((packed))
{
	word	offset_l;	///< Parte baja del desplazamiento    
	word	segment;	///< Selector    
	byte	zero ;		///< Reservado  
	byte	config ;	///< Configuracion del descriptor 
	word	offset_h;	///< Parte alta del desplazamiento   
}desc_idt32_t;


/**
 \struct idtr_t
 \brief Tipo utilizado para definir IDTR.
*/
typedef struct __attribute__((packed))
{
	word	limit;		///< Tamaño de la IDT   
	dword	base;		///< Direccion base de la IDT 
}idtr_t;


/*
* Descriptores del directorio de paginas
*/
typedef struct __attribute__((packed))
{  
	byte	present : 1;				// En 1 indica que la pagina puede referenciarse
	byte	read_write : 1;				// Read/Write (si vale 0, es solo lectura)
	byte	user_supervisor : 1;			// User/Supervisor
	byte	pwt : 1;				// Page level write
	byte	pcd : 1;				// Page level cache
	byte	accessed : 1;				// Indica si la pagina fue accedida
	byte	ignored : 1;
	byte	ps : 1;					// Tamanio de pagina, debe ser 0 si CR4.PSE=1
	byte	ignored2 : 4;	
	byte	pte_dir_l : 4;				// Direccion fisica de la tabla de pagina, parte baja
	word	pte_dir_h;				// Direccion fisica de la tabla de pagina, parte alta
}pde_4k_t;

/*
* Descriptores del directorio de paginas
*/
typedef struct __attribute__((packed))
{
	byte	present : 1;				// En 1 indica que la pagina puede referenciarse
	byte	read_write : 1;				// Read/Write (si vale 0, es solo lectura)
	byte	user_supervisor : 1;			// User/Supervisor
	byte	pwt : 1;				// Page level write
	byte	pcd : 1;				// Page level cache
	byte	accessed : 1;				// Indica si la pagina fue accedida
	byte	dirty : 1;				// Indica cuando el software escribio la pagina, utilizado para proteccion
	byte	ps : 1;					// Tamanio de pagina, debe ser 1
	byte	global : 1;				// Determina si la traduccion es global, bit CR4.PGE debe ser 1
	byte	ignored : 3;	
	byte	pat : 1;				// Si existe PAT este bit indica el tipo de memoria
	byte	pte_dir_h : 4;				// Direccion fisica de la tabla de pagina, parte alta
	byte	ignored2 : 5;	
	word	pte_dir_l : 10;				// Direccion fisica de la tabla de pagina, parte baja
}pde_4m_t;

/*
* Descriptores del directorio de paginas
*/
typedef struct __attribute__((packed))
{  
	byte	present : 1;				// En 1 indica que la pagina puede referenciarse
	byte	read_write : 1;				// Read/Write (si vale 0, es solo lectura)
	byte	user_supervisor : 1;			// User/Supervisor
	byte	pwt : 1;				// Page level write
	byte	pcd : 1;				// Page level cache
	byte	accessed : 1;				// Indica si la pagina fue accedida
	byte	dirty : 1;				// Indica cuando el software escribio la pagina, utilizado para proteccion
	byte	pat : 1;				// Si existe PAT este bit indica el tipo de memoria
	byte	global : 1;				// Determina si la traduccion es global, bit CR4.PGE debe ser 1
	byte	ignored : 3;	
	byte	phy_dir_l : 4;				// Direccion fisica de la tabla de pagina, parte baja
	word	phy_dir_h;				// Direccion fisica de la tabla de pagina, parte alta
}pte_t;


#endif /*__ASM_X86_PROCESSOR_TYPES_H  0*/
