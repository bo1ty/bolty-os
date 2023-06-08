[org 0x7c00]
[bits 16]

start:
	jmp main16

print:
	pusha
	mov ah, 0eh             	; set teletype mode
	jmp .loop
	.loop:
		lodsb               	; mov char at si in al
		cmp al, 0
		jz .done				; jmp if null
		int 10h
		jmp .loop				; loop
	.done:
		popa
		ret

read_disk:
	pusha
	mov bx, 0x7e00
	mov ah, 2               	; read mode
	mov al, 1               	; read 1 sector
	mov ch, 0               	; cylinder 0
	mov dh, 0               	; head 0
	mov cl, 2               	; sector 2
	mov dl, [BOOT_DISK]     	; set drive number
	int 13h
	jc .disk_error				; jmp if carry
	cmp ah, 0					; 0 = no error
	jne .disk_error				; jmp if error
	popa
	ret
	.disk_error:
		mov si, DISK_ERR_MSG
		call print
		popa
		ret

code_seg equ code_descriptor - gdt_start
data_seg equ data_descriptor - gdt_start

gdt_start:
	null_descriptor: dd 0, 0
	code_descriptor:
		dw 0xffff				; limit
		dw 0					; base = 32 bits total, this line = 16 bits for base
		db 0					; 8 bits for base
		db 0b10011010			; p.p.t. + type flags
		db 0b11001111			; other flags + last four bits of limit	
		db 0					; 8 bits for base
	data_descriptor:			; same for this
		dw 0xffff
		dw 0
		db 0
		db 0b10010010
		db 0b11001111
		db 0
gdt_end:
gdt_descriptor:
	dw gdt_end - gdt_start - 1	; size of gdt
	dd gdt_start				; pointer to start

main16:
	mov ah, 0
	mov al, 03h
	int 10h						; clear screen

	mov ax, 0					; setup segments
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00

	cli							; clear interrupts
	lgdt [gdt_descriptor]		; load gdt
	mov eax, cr0				; change last bit of cr0 to 1
	or eax, 1
	mov cr0, eax				; start of 32 bit mode
	jmp code_seg:main32			; jmp to protected mode
	jmp $

[bits 32]

main32:
	
	jmp $

DISK_ERR_MSG: db 'Disk Error!', 0
BOOT_DISK: db 0

times 510-($-$$) db 0
dw 0xaa55