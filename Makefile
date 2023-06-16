BUILD_DIR=build

.PHONY: all
all: clean compile

.PHONY: clean
clean:
	rm -rf build/*
	mkdir -p $(BUILD_DIR)

.PHONY: compile
compile:
	make -C boot all
	make -C kernel all
	cat $(BUILD_DIR)/boot.bin $(BUILD_DIR)/full_kernel.bin > $(BUILD_DIR)/os.bin

.PHONY: run
run:
	qemu-system-x86_64 -drive file=$(BUILD_DIR)/os.bin,format=raw,index=0,media=disk