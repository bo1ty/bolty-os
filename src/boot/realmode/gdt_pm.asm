code32_seg equ code32_descriptor - gdt32_start
data32_seg equ data32_descriptor - gdt32_start

gdt32_start:
	null32_descriptor: dd 0, 0
	code32_descriptor:
		dw 0xffff											; limit
		dw 0												; base = 32 bits total, this line = 16 bits for base
		db 0												; 8 bits for base
		db 0b10011010										; p.p.t. + type flags
		db 0b11001111										; other flags + last four bits of limit	
		db 0												; 8 bits for base
	data32_descriptor:										; same for this
		dw 0xffff
		dw 0
		db 0
		db 0b10010010
		db 0b11001111
		db 0
gdt32_end:
gdt32_descriptor:
	dw gdt32_end - gdt32_start - 1							; size of gdt
	dd gdt32_start											; pointer to start