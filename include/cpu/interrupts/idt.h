#pragma once

#include "stdint.h"

typedef enum {
  IDT_FLAG_GATE_INTERRUPT = 0xE,
  IDT_FLAG_GATE_TRAP = 0xF,

  IDT_FLAG_RING0 = (0 << 5),
  IDT_FLAG_RING1 = (1 << 5),
  IDT_FLAG_RING2 = (2 << 5),
  IDT_FLAG_RING3 = (3 << 5),

  IDT_FLAG_PRESENT = (1 << 7),
} IDT_FLAGS;

void idt_setgate_amd64(int interrupt, void *base, uint16_t segmentSelector,
                       int8_t flags);
void idt_enablegate_amd64(int interrupt);
void idt_disablegate_amd64(int interrupt);
void idt_init_amd64();