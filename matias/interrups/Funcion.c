
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

