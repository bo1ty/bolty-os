[org 0x7c00]
[bits 16]

start:
	jmp main16


main16:
	mov [BOOT_DISK], dl

	mov ax, 0
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00

	mov al, 2
	call read_disk
	jmp elevate_pm
	jmp $

%include "boot/realmode/functions.asm"
%include "boot/realmode/gdt_pm.asm"
%include "boot/realmode/elevate_pm.asm"

DISK_ERR_MSG: db 'Disk Error!', 0
BOOT_DISK: db 0

times 510-($-$$) db 0
dw 0xaa55

[bits 32]

KERNEL_LOCATION equ 0x8000

main32:
	call check_cpuid										; check for cpuid	
	call check_longmode										; check for longmode
	call setup_paging										; setup PAE paging
	jmp elevate_lm
	jmp $

%include "boot/protectedmode/print.asm"
%include "boot/protectedmode/clear.asm"
%include "boot/protectedmode/check_lm.asm"
%include "boot/protectedmode/gdt_lm.asm"
%include "boot/protectedmode/paging.asm"
%include "boot/protectedmode/elevate_lm.asm"

[bits 64]

main64:
	jmp KERNEL_LOCATION

times 512-($-main32) db 0