/** \def BYTE */
typedef unsigned char byte;   ///<Tipo byte
/** \def WORD */
typedef unsigned short word;  ///<Tipo word
/** \def DWORD */
typedef unsigned long dword;  ///<Tipo dword
/** \def QWORD */
typedef unsigned long long qword;   ///<Tipo qword
/** \def TICKS_T */
typedef unsigned long long int ticks_t;   ///<Tipo para timer tick

//termine con lo prototipos
extern		__sys_tables_start;
extern		__main_start;
extern		__mdata_start;
extern		__bss_start;
extern		__funcion_start	;



 void clrscr(void)
{
   //screen size 80*25 =2000
   int i=0;
   unsigned char *video= (unsigned char *)0xB8000;
   
   for(i=0;i<2000;i=i+2)
   {
      *(video+i)=0x00;//this one sets background color
      *(video+i+1)=0x00;
   } 
}
//*************************************************
// funcion para escribir en pantalla desde c
//*************************************************
//print_pos= VGA_RAM+(2*CANT_COLUMNA)*COLUMNA+2*FILA
void Print_c( const char *string,char fila, char columna , int color )
{
#define VGA_RAM 0xB8000
    volatile char *video = (volatile char*)VGA_RAM;
    video=video+(2*columna)*80+2*fila;
    
    while( *string != 0 )
    {
        *video++ = *string++;
        *video++ = color;
    }
}
//*************************************************
// funcion para escribir en pantalla desde c
//*************************************************
//print_pos= VGA_RAM+(2*CANT_COLUMNA)*COLUMNA+2*FILA
void Print_char( const char string,char fila, char columna , int color )
{
#define VGA_RAM 0xB8000
    volatile char *video = (volatile char*)VGA_RAM;
    video=video+(2*columna)*80+2*fila;
    
    
    
        *video++ = string;
        *video++ = color;
    
}
//convierte el scan code a ascii segun la tabla de 
//http://wiki.osdev.org/PS2_Keyboard#See_Also
//uso el scan code set1
char scanCode2ascii(char Scode)
{char ascii=0xff;
	switch(Scode)
	{
	case 0x10: ascii= 'q';break;
	case 0x11: ascii= 'w';break;
	case 0x12: ascii= 'e';break;
	case 0x13: ascii= 'r';break;
	case 0x14: ascii= 't';break;
	case 0x15: ascii= 'y';break;
	case 0x16:ascii= 'u';break;
	case 0x17:ascii= 'i';break;
	case 0x18:ascii= 'o';break;
	case 0x19:ascii= 'p';break;
	
	case 0x1E:ascii= 'a';break;
	case 0x1f:ascii= 's';break;
	case 0x20:ascii= 'd';break;
	case 0x21:ascii= 'f';break;
	case 0x22:ascii= 'g';break;
	case 0x23:ascii= 'h';break;
	case 0x24:ascii= 'j';break;
	case 0x25:ascii= 'k';break;
	case 0x26:ascii= 'l';break;
	
	case 0x2C:ascii= 'z';break;
	case 0x2d:ascii= 'x';break;
	case 0x2e:ascii= 'c';break;
	case 0x2f:ascii= 'v';break;
	case 0x30:ascii= 'b';break;
	case 0x31:ascii= 'n';break;
	case 0x32:ascii= 'm';break;
	
	
	}
	return (ascii);
}

void CreoPagina(dword *cr3,dword  dir_fisica,dword DirLineal)
{
dword cr3aux=*cr3, altaDirLineal,mediaDirLineal;
//dword PD_base;
dword *PT_base;
dword *PDE;
dword *PTE;

PDE=cr3;
PTE=cr3;

	altaDirLineal=(DirLineal|0xffc00000)>>22;
	mediaDirLineal=(DirLineal|0x003FF000)>>12;
	
	
	PDE=PDE+altaDirLineal; //entro a al directorio 
	*(PDE)=(cr3aux+4096+altaDirLineal*4096)+0x7 ; //esccribo el directorio en la posicion n la addr de la tabla
		
	PT_base=(cr3aux+4096+altaDirLineal*4096);
	
	PTE=PT_base+mediaDirLineal;//
	*(PTE)= dir_fisica +0x3 ; //esccribo el directorio en la posicion n la addr de la tabla
}



void PaginarKernel(dword* cr3)
{


	CreoPagina(cr3,0xa0000,0xa0000);
/*	CreoPagina(cr3,(dword)__sys_tables_start,(dword)__sys_tables_start);
	CreoPagina(cr3,(dword)__main_start,(dword)__main_start);
	CreoPagina(cr3,(dword)__mdata_start,(dword)__mdata_start);
	CreoPagina(cr3,(dword)__bss_start,(dword)__bss_start);
	CreoPagina(cr3,(dword)__funcion_start,(dword)__funcion_start);
	CreoPagina(cr3,(dword)0xb8000,0xb8000);
	CreoPagina(cr3,(dword)0xffff0000,0xffff0000);
	*/
}


