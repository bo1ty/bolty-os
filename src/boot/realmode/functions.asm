print:
	pusha
	mov ah, 0eh												; set teletype mode
	jmp .loop
	.loop:
		lodsb												; mov char at si in al
		cmp al, 0
		jz .done											; jmp if null
		int 10h
		jmp .loop											; loop
	.done:
		popa
		ret

read_disk:
	mov bx, 0x7e00
	mov ah, 2												; read mode
	mov ch, 0												; cylinder 0
	mov dh, 0												; head 0
	mov cl, 2												; sector 2
	mov dl, [BOOT_DISK]										; set drive number
	int 13h
	jc .disk_error											; jmp if carry
	cmp ah, 0												; 0 = no error
	jne .disk_error											; jmp if error
	ret
	.disk_error:
		mov si, DISK_ERR_MSG
		call print
		ret
