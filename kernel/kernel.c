#include "cpu/interrupts/idt.h"
#include "drivers/vga.h"

extern int main() {
  idt_init_amd64();
  clear_tty();
  *((char *)0xb8000) = 'A';
  return 0;
}