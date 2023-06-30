#include "idt.h"
#include <stdint.h>

#define FLAG_SET(flag, value) flag |= (value)
#define FLAG_UNSET(flag, value) flag &= ~(value)

typedef struct {
  uint16_t offset_1; // offset bits 0..15
  uint16_t selector; // segment selector
  uint8_t ist;       // ist in bits 0..2, rest are reserved
  uint8_t flags;     // gate type, dpl, p
  uint16_t offset_2; // offset bits 16..31
  uint32_t offset_3; // offset bits 32..63
  uint32_t reserved; // reserved
} __attribute__((packed)) IDT_ENTRY;

typedef struct {
  uint16_t size;  // size of idt
  IDT_ENTRY *ptr; // ptr to idt
} __attribute__((packed)) IDT_DESCRIPTOR;

IDT_ENTRY sys_idt[256];
IDT_DESCRIPTOR sys_idt_descriptor = {sizeof(sys_idt) - 1, sys_idt};

void idt_load_amd64(IDT_DESCRIPTOR *idtDescriptor) {
  __asm__ volatile("lidt (%0)" : : "r"(idtDescriptor));
}

void idt_init_amd64() { idt_load_amd64(&sys_idt_descriptor); }

void idt_setgate_amd64(int interrupt, void *base, uint16_t segmentSelector,
                       int8_t flags) {
  sys_idt[interrupt].offset_1 = (uintptr_t)base & 0xFFFF;
  sys_idt[interrupt].selector = segmentSelector;
  sys_idt[interrupt].ist = 0;
  sys_idt[interrupt].flags = flags;
  sys_idt[interrupt].offset_2 = ((uintptr_t)base >> 16) & 0xFFFF;
  sys_idt[interrupt].offset_3 = ((uintptr_t)base >> 32) & 0xFFFFFFFF;
  sys_idt[interrupt].reserved = 0;
}

void idt_enablegate_amd64(int interrupt) {
  FLAG_SET(sys_idt[interrupt].flags, IDT_FLAG_PRESENT);
}

void idt_disablegate_amd64(int interrupt) {
  FLAG_UNSET(sys_idt[interrupt].flags, IDT_FLAG_PRESENT);
}