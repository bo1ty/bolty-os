CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ASM = nasm

CC_FLAGS = -ffreestanding -m64 -c
LD_FLAGS = -Ttext 0x8000 --oformat binary
ASM_FLAGS = -f elf64

BUILD_DIR=../build

FILES_C = $(shell find . -type f -name "*.c")
FILES_ASM = $(shell find . -type f -name "*.asm")
FILES_OBJ = ${FILES_ASM:.asm=.o} ${FILES_C:.c=.o} 

.PHONY: all
all: $(FILES_OBJ) kernel

%.o: %.c
	$(CC) $(CC_FLAGS) $^ -o $(BUILD_DIR)/$@

%.o: %.asm
	$(ASM) $^ ${ASM_FLAGS} -o $(BUILD_DIR)/$@

kernel: $(OBJ)
	$(LD) -o $(BUILD_DIR)/full_kernel.bin $(LD_FLAGS) $(foreach file, $(FILES_OBJ), $(BUILD_DIR)/$(subst ./,,$(file)))


.PHONY: test
test:
	echo $(FILES_OBJ)