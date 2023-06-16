section .text
    [bits 64]
    [extern main]
    call main
    jmp $