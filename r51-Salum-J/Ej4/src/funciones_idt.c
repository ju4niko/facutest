/** 
	\file  funciones_idt.c	
	\version 01.00
	\brief Definicion de funciones relacionadas con la idt del procesador en 32b

	\author Christian Nigri <cnigri@utn.edu.ar>
	\date    18/04/2017
*/

#include "header/x86_types.h"
#include "header/sys_types.h"


/***************************************************************************//**
*
* @fn         __lidt
*
* @brief      Cargo la idt en el registro.
*
* @param [in] reg tipo puntero a word. Especifica la direccion de inicio del
*             registro de la idt.
*
******************************************************************************/
__attribute__(( section(".start32"))) static void __lidt(dword *reg) 			// static para que sea visible solo en este fichero
{
    __asm__ __volatile__ ("lidt (%0)" : : "q" (reg));					// volatile para que no me optimice codigo

}


/***************************************************************************//**
*
* @fn         __init_idt
*
* @brief      Esta funcion permite inicialiar la IDT utilizando valores por
*             defecto (TRAP GATE, 32b, offset 0, selector nulo, DPL0).
*
* @param [in] idt_start tipo double word. Especifica la direccion de inicio de
*             la tabla.
* @param [in] idt_length tipo byte. Especifica la longitud de la tabla expresada
*             en descriptores..
*
******************************************************************************/
__attribute__(( section(".start32"))) void __init_idt(dword idt_start, byte idt_length)
{
   byte idt_index;
   idtr_t idt_r;
   desc_idt32_t *idt_entry = (desc_idt32_t *) idt_start;
 
   for( idt_index = 0; idt_index < idt_length; idt_index++ )
   {
      idt_entry->offset_l = 0x0;
      idt_entry->segment = 0x0;
      idt_entry->zero = 0x0;
      idt_entry->config = DPL0 | EXC_GATE | GATE32;
      idt_entry->offset_h = 0x0;
      idt_entry++;
   }

    idt_r.limit = idt_length*8;
    idt_r.base = idt_start;
    __lidt( (dword*) &idt_r );

   return;
}


/***************************************************************************//**
*
* @fn         __set_idt_entry
*
* @brief      Esta funcion inicializa el descriptor entry, en un offset, con los
*             attributos y el selector. 
*             En caso de exito retorna EXITO o ERROR_DEFECTO en cualquier otra 
*             circunstancia
*
* @param [in] entry tipo byte. Especifica el descriptor a inicializar.
*
* @param [in] selector tipo word. Especifica el selector del segmento de codigo
*             utilizado por la rutina de atencion.
*
* @param [in] offset tipo double word. Especifica el desplazamiento del inicio 
*             de la rutina de atnecion.
*
* @param [in] attr tipo byte. Especifica los atributos del descriptor. Los 
*             valores se definen en x86_types.
*
* @return     tipo byte indicando si falla o no.
*
******************************************************************************/
__attribute__(( section(".start32"))) byte __set_idt_entry(byte entry, word selector, dword offset, byte attr)
{

   desc_idt32_t *idt_entry;
   idtr_t idt_r;
   byte status = ERROR_DEFECTO;

   __asm__ __volatile__ ("sidt %0" : "=m" (idt_r));

   if(idt_r.limit >= entry)
   {
      idt_entry = (desc_idt32_t *) ( idt_r.base + ( entry * sizeof(desc_idt32_t) ) );
      idt_entry->offset_l = (word) (offset & 0xffff);
      idt_entry->segment = (word)selector;
      idt_entry->config = (byte) attr;
      idt_entry->offset_h  = (word) ((offset & 0xffff0000) >> 16);
      status = EXITO;   
   }

   return(status);
}
