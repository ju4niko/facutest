# CARPETAS
LINKERPATH	=	linker
SRCPATH		=	src
ELFPATH		=	$(SRCPATH)/elf
LISTPATH	=	$(SRCPATH)/list
BINPATH		=	binario

# ENSAMBLADOR DE ASM
AC		=	nasm
AFLAGS		=	-f elf32								# -f elf64

# ENSAMBLADOR DE C
CC		=	gcc
CFLAGS		=	-c -m32 -fno-stack-protector -fno-asynchronous-unwind-tables -Wall	# -fno-asynchronous-unwind-tables quitar para tener incorporar la eh_frame

# LINKER
LDFLAGS		=	-z max-page-size=0x01000 --oformat=binary -m elf_i386			# -m elf_x86_64 -s
LDFLAGS2	=	-z max-page-size=0x01000 -m elf_i386
EXTERN		=	start16_inic 

# OBJETO
ODFLAGS		=	-CprsSx --prefix-addresses

# PATH DE UBICACION DE CADA ARCHIVO
ASRCS		= 	$(wildcard $(SRCPATH)/*.s)
AOBJS		= 	$(addprefix $(ELFPATH)/,$(notdir $(ASRCS:.s=.elf)))
ALIST		= 	$(addprefix $(LISTPATH)/,$(notdir $(ASRCS:.s=.list)))
CSRCS		= 	$(wildcard $(SRCPATH)/*.c)
COBJS		= 	$(addprefix $(ELFPATH)/,$(notdir $(CSRCS:.c=.elf)))
OBJS		= 	$(AOBJS) $(COBJS)
LDSCRIPT	= 	$(wildcard $(LINKERPATH)/*.lds)

# ARCHIVO GENERADO POR EL LINKER Y OTROS
SALIDA 		=	fichero
BINARIO		=	$(SALIDA).bin
MAPA		=	$(SALIDA).map
ELF		=	$(SALIDA).elf

# ENSAMBLO, LINKEO, CREO ARCHIVOS DE LECTURA
todo: $(BINARIO) $(ELF) $(ALIST)
	hexdump -C $(BINPATH)/$(BINARIO) > $(BINPATH)/$(SALIDA)_hexdump.txt
	objdump $(ODFLAGS) $(BINPATH)/$(ELF) > $(BINPATH)/$(SALIDA)_objdump.txt
	readelf -a $(BINPATH)/$(ELF) > $(BINPATH)/$(SALIDA)_readelf.txt
	rm $(SRCPATH)/*.o

$(BINARIO): $(OBJS)
	ld $(LDFLAGS) -T $(LDSCRIPT) -e $(EXTERN) $(OBJS) -o $(BINPATH)/$@ -Map $(BINPATH)/$(MAPA)
$(ELF): $(OBJS)
	ld $(LDFLAGS2) -T $(LDSCRIPT) -e $(EXTERN) $(OBJS) -o $(BINPATH)/$@

$(ELFPATH)/%.elf: $(SRCPATH)/%.c
	$(CC) $(CFLAGS) $^ -o $@

$(ELFPATH)/%.elf: $(SRCPATH)/%.s
	$(AC) $(AFLAGS) $^ -o $@

$(LISTPATH)/%.list: $(SRCPATH)/%.s
	$(AC) $(AFLAGS) $^ -l $@

# BORRO TODOS LOS ARCHIVOS CREADOS POR 'todo'
borrar:
	rm $(BINPATH)/* $(ELFPATH)/* $(LISTPATH)/*

# COMPRIMIR ARCHIVOS IMPORTANTES PARA ENVIAR
comprimir:
	tar zcvf proyecto.tar.gz $(LDSCRIPT) $(ASRCS) $(CSRCS) $(BINPATH)/$(BINARIO) Makefile

# SI NO EXISTE LA CARPETA, LA CREO
carpetas:
	mkdir $(LINKERPATH) $(SRCPATH) $(ELFPATH) $(LISTPATH) $(BINPATH)
