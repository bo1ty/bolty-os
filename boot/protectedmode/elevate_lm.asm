elevate_lm:
	mov ecx, 0xC0000080	
	rdmsr
	or eax, 1 << 8
	wrmsr
	mov eax, cr0
	or eax, 1 << 31
	mov cr0, eax	

	lgdt [gdt64.gdt64_descriptor]							; load 64 bit gdt
	jmp code64_seg:init_lm									; Set the code segment and enter 64-bit long mode.

init_lm:
	cli
	mov ax, data64_seg
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax

	jmp main64
