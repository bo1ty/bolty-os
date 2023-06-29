CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ASM = nasm

CC_FLAGS = -ffreestanding -m64 -c -I ./include/
LD_FLAGS = -Ttext 0x8000 --oformat binary
ASM_FLAGS = -f elf64

BUILD_DIR=build

CSRC := $(shell find . -name '*.c')
CTAR := $(patsubst %.c,%.o,$(CSRC))

ASMSRC := $(shell find . -name '*.asm' ! -path "./boot/*")
ASMTAR := $(patsubst %.asm,%.o,$(ASMSRC))

.PHONY: all
all: clean build run

.PHONY: clean
clean:
	rm -rf build/*
	mkdir -p $(BUILD_DIR)

.PHONY: boot
boot:
	nasm boot/boot.asm -f bin -o $(BUILD_DIR)/boot.bin

.PHONY: build
build: boot $(CTAR) $(ASMTAR)
	$(LD) -o $(BUILD_DIR)/full_kernel.bin $(LD_FLAGS) $(foreach file, $(ASMTAR) $(CTAR), $(BUILD_DIR)/$(subst ./,,$(file)))
	cat $(BUILD_DIR)/boot.bin $(BUILD_DIR)/full_kernel.bin > $(BUILD_DIR)/os.bin

%.o: %.c
	mkdir -p $(dir $(BUILD_DIR)/$@)
	$(CC) $(CC_FLAGS) $^ -o $(BUILD_DIR)/$@

%.o: %.asm
	mkdir -p $(dir $(BUILD_DIR)/$@)
	$(ASM) $^ ${ASM_FLAGS} -o $(BUILD_DIR)/$@

.PHONY: run
run:
	qemu-system-x86_64 -drive file=$(BUILD_DIR)/os.bin,format=raw,index=0,media=disk

.PHONY: test
test:
	echo $(CSRC)