code64_seg equ gdt64.code64_descriptor - gdt64
data64_seg equ gdt64.data64_descriptor - gdt64

gdt64:
	.null64_descriptor:
		dq 0
	.code64_descriptor:
		dd 0xFFFF											; limit + base (low, bits 0-15)
		db 0												; base (mid, bits 16-23)
		db 0b10011010										; access
		db 0b10101111										; flags + limit (high, bits 16-19)
		db 0												; base (high, bits 24-31)
	.data64_descriptor:
		dd 0xFFFF											; limit + base (low, bits 0-15)
		db 0												; base (mid, bits 16-23)
		db 0b10010010										; access
		db 0b11001111										; flags + limit (high, bits 16-19)
		db 0												; base (high, bits 24-31)
	.tss:
		dd 0x00000068
		dd 0x00CF8900
	.gdt64_descriptor:
		dw $ - gdt64 - 1
		dq gdt64