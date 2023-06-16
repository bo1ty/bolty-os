print_pm:
	pushad
	mov ah, 0x0f
	mov edi, 0xb8000
	.print_pm_loop:
		lodsb
		cmp al, 0
		jz .print_pm_end
		mov [edi], al
		add edi, 2
		jmp .print_pm_loop
	.print_pm_end:
		popad
		ret