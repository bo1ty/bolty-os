QEMU=qemu-system-x86_64
GCC=/usr/local/i386elfgcc/bin/i386-elf-gcc
LINKER=/usr/local/i386elfgcc/bin/i386-elf-ld

BUILD_DIR=build

.PHONY: run
run: compile
	@$(QEMU) -drive file=$(BUILD_DIR)/toast.bin,format=raw,index=0,media=disk

.PHONY: compile
compile:
	@mkdir -p $(BUILD_DIR)
	@nasm boot/boot.asm -f bin -o $(BUILD_DIR)/toast.bin

.PHONY: clean
clean:
	@rm -rf build/*