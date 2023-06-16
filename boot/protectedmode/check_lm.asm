check_cpuid:
	pushfd													; copy flags into eax via stack
	pop eax
	mov ecx, eax											; copy to ecx for comparing
	xor eax, 1 << 21										; flip id bit
	push eax												; move eax back to flags
	popfd
	pushfd													; reverse last operation, bit should be
	pop eax													; flipped if CPUID is supported
	push ecx												; restore original flags
	popfd
	xor eax, ecx											; compare
	jz no_longmode											; if equal then bit wasn't flipped
	ret														; and CPUID isn't supported

check_longmode:
	mov eax, 0x80000000
	cpuid
	cmp eax, 0x80000001
	jb no_longmode

	mov eax, 0x80000001
	cpuid
	test edx, 1 << 29
	jz no_longmode
	ret

no_longmode:
	mov al, 'E'
	mov ah, 0x0f
	mov [0xb8000], ax
	jmp $

NO_LM_ERR: db 'Long Mode is Not Available!', 0