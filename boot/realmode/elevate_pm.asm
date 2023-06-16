elevate_pm:
	in al, 0x92
	or al, 2
	out 0x92, al	

	cli														; clear interrupts
	lgdt [gdt32_descriptor]									; load gdt
	mov eax, cr0											; change last bit of cr0 to 1
	or eax, 1
	mov cr0, eax											; start of 32 bit mode
	jmp code32_seg:init_pm									; jmp to protected mode

[bits 32]

init_pm:
	mov ax, data32_seg
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	jmp main32