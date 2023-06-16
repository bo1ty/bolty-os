clear_screen_pm:
	pushad
	mov ebx, 4000
	mov ecx, 0xb8000
	mov edx, 0
	.clear_screen_pm_loop:
		cmp edx, ebx
		jge .clear_screen_pm_done
		push edx
		mov al, ' '
		mov ah, 0x0f
		add edx, ecx
		mov WORD [edx], ax
		pop edx
		add edx, 2
		jmp .clear_screen_pm_loop

	.clear_screen_pm_done:
		popad
		ret
