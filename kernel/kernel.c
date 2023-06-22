#include "../include/drivers/vga.h"

extern int main() {
    *(char *) 0xb8000 = 'A';
    clear_tty();
    return 0;
}