CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ASM = nasm

CC_FLAGS = -ffreestanding -m64 -c
LD_FLAGS = -Ttext 0x8000 --oformat binary
ASM_FLAGS = -f elf64

BUILD_DIR=build
SRC_DIR=src

CSRC := $(shell find . -name '*.c')
CTAR := $(patsubst %.c,%.o,$(CSRC))

INCDIRS := $(foreach dir,$(shell find include -type d),-I$(dir))

ASMSRC := $(shell find . -name '*.asm' ! -path "./src/boot/*")
ASMTAR := $(patsubst %.asm,%.o,$(ASMSRC))

.PHONY: all
all: clean build run

.PHONY: clean
clean:
	rm -rf build/*
	mkdir -p $(BUILD_DIR)

.PHONY: boot
boot:
	mkdir -p build/boot
	nasm $(SRC_DIR)/boot/boot.asm -f bin -o $(BUILD_DIR)/boot/boot.bin

.PHONY: build
build: boot $(CTAR) $(ASMTAR)
	$(LD) -o $(BUILD_DIR)/kernel/kernel.bin $(LD_FLAGS) $(foreach file, $(ASMTAR) $(CTAR), $(BUILD_DIR)/$(subst ./$(SRC_DIR)/,,$(file)))
	cat $(BUILD_DIR)/boot/boot.bin $(BUILD_DIR)/kernel/kernel.bin > $(BUILD_DIR)/os.bin

%.o: %.c
	mkdir -p $(dir $(BUILD_DIR)/$(subst src/,,$@))
	$(CC) $(CC_FLAGS) $(INCDIRS) $^ -o $(BUILD_DIR)/$(subst src/,,$@)

%.o: %.asm
	mkdir -p $(dir $(BUILD_DIR)/$(subst src/,,$@))
	$(ASM) $^ ${ASM_FLAGS} -o $(BUILD_DIR)/$(subst src/,,$@)

.PHONY: run
run:
	qemu-system-x86_64 -drive file=$(BUILD_DIR)/os.bin,format=raw,index=0,media=disk