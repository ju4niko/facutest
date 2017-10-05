
#include "header/x86_types.h"
#include "header/sys_types.h"

/*****************************************************************************
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
__attribute__(( section(".start32") )) byte __fast_memcpy(const byte *src, byte *dst, dword length)
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


/*****************************************************************************
*
* @fn         __inic_pde_pte
*
* @brief      Esta funcion inicializa los descriptores del directorio de paginas
*	      y de la tabla de paginas
*
* @param [in] src_pde puntero tipo double word. Especifica la direccion de inicio.
*
* @param [in] src_pte puntero tipo double word. Especifica la direccion de inicio.
*
* @return     void.
*
******************************************************************************/
__attribute__(( section(".start32") )) void __inic_pde_pte( dword *src_pde, dword *src_pte )
{
	unsigned int i = 0;
	for( i = 0 ; i < 1024 ; i++ ){
		*src_pde = 0; src_pde++;
		*src_pte = 0; src_pte++;
	}
}


/*****************************************************************************
*
* @fn         __set_ptree_32_entry
*
* @brief      Esta funcion carga la pde y pte para localizar la direccion lineal
*
* @param [in] page_size tipo byte. Especifica el tamanio de pagina (4K o 4M).
*
* @param [in] ptree_base puntero tipo const double word. Especifica la direccion del pde.
*
* @param [in] addr_phy tipo double word. Especifica la direccion fisica traducida de la lineal.
*
* @param [in] addr_lin tipo double word. Especifica la direccion lineal a traducir.
*
* @param [in] page_attr tipo byte. Especifica los atributos de la pagina.
*
* @return     tipo byte indicando si falla o no.
*
******************************************************************************/
__attribute__(( section(".start32") )) byte __set_ptree32( const dword src_pde, const dword src_pte, byte pde_attr, dword addr_phy, dword addr_lin, byte page_attr )
{
	byte status = ERROR_SETEO_PAG;
	dword ptree_pd = ((addr_lin & 0xFFC00000) >> 22)*4;						// Direccion directorio
	dword ptree_pt = ((addr_lin & 0x003FF000) >> 12)*4;						// Direccion de tabla
	pte_t *ptree_pte = (pte_t*) ((src_pte & 0xFFFFF000) + ptree_pt);				// Apunto a la direccion dentro de la tabla de pagina
	
	if( !((pde_attr & 0x80) >> 7) ){								// Depende del tamanio de pagina a setear
		pde_4k_t *ptree_pde = (pde_4k_t*) ((src_pde & 0xFFFFF000) + ptree_pd);			// Apunto a la direccion dentro del directorio de pagina

		if( ptree_pde->present == 0 ){								// Si no esta inicializado, lo hago
			ptree_pde->present = (pde_attr & 0x01); 					// Indico que voy a inicializar una pagina
			ptree_pde->read_write = (pde_attr & 0x02) >> 1;					// Lectura o escritura
			ptree_pde->user_supervisor = (pde_attr & 0x04) >> 2;				// Usuario o supervisor
			ptree_pde->pwt = (pde_attr & 0x08) >> 3;
			ptree_pde->pcd = (pde_attr & 0x10) >> 4;
			ptree_pde->accessed = (pde_attr & 0x20) >> 5;
			ptree_pde->ignored = 0;
			ptree_pde->ps = (pde_attr & 0x80) >> 7; 					// Deberia ser cero ya que es una pagina de 4K
			ptree_pde->ignored2 = 0;
			ptree_pde->pte_dir_l = (src_pte >> 12) & 0x0000F;				// Me quedo con los 4 bit menos significativos (luego de los primeros 3)
			ptree_pde->pte_dir_h = (src_pte >> 16) & 0xFFFF;				// Me quedo con los 16 bits mas significativos
		}
	}
	else{
		pde_4m_t *ptree_pde = (pde_4m_t*) ((src_pde & 0xFFFFF000) + ptree_pd);			// Apunto a la direccion dentro del directorio de pagina

		if( ptree_pde->present == 0 ){ 								// Si no esta inicializado, lo hago
			ptree_pde->present = (pde_attr & 0x0001); 					// Indico que voy a inicializar una pagina
			ptree_pde->read_write = (pde_attr & 0x0002) >> 1;				// Lectura o escritura
			ptree_pde->user_supervisor = (pde_attr & 0x0004) >> 2;				// Usuario o supervisor
			ptree_pde->pwt = (pde_attr & 0x0008) >> 3;						
			ptree_pde->pcd = (pde_attr & 0x0010) >> 4;
			ptree_pde->accessed = (pde_attr & 0x0020) >> 5;
			ptree_pde->dirty = (pde_attr & 0x0040) >> 6;
			ptree_pde->ps = (pde_attr & 0x0080) >> 7; 					// Deberia ser uno ya que es una pagina de 4M
			ptree_pde->global = (pde_attr & 0x0100) >> 8;
			ptree_pde->ignored = 0;
			ptree_pde->pat = (pde_attr & 0x1000) >> 13;
			ptree_pde->ignored2 = 0;
			ptree_pde->pte_dir_l = (src_pte >> 12) & 0x003FF;				// Me quedo con los 10 bit menos significativos (luego de los primeros 3)
			ptree_pde->pte_dir_h = ((src_pte >> 22) & 0x0F);				// Me quedo con los 4 bits mas significativos
		}
	}

	if(ptree_pte->present == 0){ 									// Si no esta inicializado, lo hago
		ptree_pte->present = (page_attr & 0x001); 						// Indico que voy a inicializar una pagina
		ptree_pte->read_write = (page_attr & 0x002) >> 1;
		ptree_pte->user_supervisor = (page_attr & 0x004) >> 2;
		ptree_pte->pwt = (page_attr & 0x008) >> 3;
		ptree_pte->pcd = (page_attr & 0x010) >> 4;
		ptree_pte->accessed = (page_attr & 0x020) >> 5;
		ptree_pte->dirty = (page_attr & 0x040) >> 6;
		ptree_pte->pat = (page_attr & 0x080) >> 7;
		ptree_pte->global = (page_attr & 0x100) >> 8;
		ptree_pte->ignored = 0;
		ptree_pte->phy_dir_l = (addr_phy >> 12) & 0x0F;						// Me quedo con los 4 bit menos significativos (luego de los primeros 3)
		ptree_pte->phy_dir_h = (addr_phy >> 16) & 0xFFFF;					// Me quedo con los 16 bits mas significativos
		status = SETEO_PAG_OK;
	}
	return(status);
}
