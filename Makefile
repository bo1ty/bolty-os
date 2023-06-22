CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ASM = nasm

CC_FLAGS = -ffreestanding -m64 -c -I ../include
LD_FLAGS = -Ttext 0x8000 --oformat binary
ASM_FLAGS = -f elf64

BUILD_DIR=build

C_SOURCES := $(shell find . -name '*.c' ! -path "./boot/*")
ASM_SOURCES := $(shell find . -name '*.asm' ! -path "./boot/*")
FILES_OBJ = ${ASM_SOURCES:.asm=.o} ${C_SOURCES:.c=.o} 

.PHONY: all
all: clean compile run

.PHONY: clean
clean:
	rm -rf build/*
	mkdir -p $(BUILD_DIR)

.PHONY: compile
compile: bootloader kernel
	cat $(BUILD_DIR)/boot.bin $(BUILD_DIR)/full_kernel.bin > $(BUILD_DIR)/os.bin

.PHONY: bootloader
bootloader:
	nasm boot/boot.asm -f bin -o $(BUILD_DIR)/boot.bin

.PHONY: kernel
kernel: $(FILES_OBJ) kernel_link

%.o: %.c
	mkdir -p $(dir $(BUILD_DIR)/$@)
	$(CC) $(CC_FLAGS) $^ -o $(BUILD_DIR)/$@

%.o: %.asm
	mkdir -p $(dir $(BUILD_DIR)/$@)
	$(ASM) $^ ${ASM_FLAGS} -o $(BUILD_DIR)/$@

kernel_link:
	$(LD) -o $(BUILD_DIR)/full_kernel.bin $(LD_FLAGS) $(foreach file, $(FILES_OBJ), $(BUILD_DIR)/$(subst ./,,$(file)))

.PHONY: run
run:
	qemu-system-x86_64 -drive file=$(BUILD_DIR)/os.bin,format=raw,index=0,media=disk

.PHONY: test
test:
	echo $(C_SOURCES)