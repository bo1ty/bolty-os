#include "drivers/vga.h"

#define VIDEO_MEMORY ((char*) 0xb8000)

void clear_tty() {
    for (char* i = (char*)VIDEO_MEMORY; i < (char*)(VIDEO_MEMORY + 4000); i+=2) {
        // 0x0f = white on black, 0x20 = space
        *((short*)i) = 0x0f20;
    }
}

void print() {
    
}