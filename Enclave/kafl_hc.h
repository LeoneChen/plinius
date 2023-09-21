#pragma once

#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

#define HYPERCALL_KAFL_PRINTF 13
#define HYPERCALL_KAFL_RAX_ID 0x01f
#define KAFL_HYPERCALL_PT(_rbx, _rcx)                                          \
  ({                                                                           \
    uint64_t _rax = HYPERCALL_KAFL_RAX_ID;                                     \
    do {                                                                       \
      asm volatile("movq %1, %%rcx;"                                           \
                   "movq %2, %%rbx;"                                           \
                   "movq %3, %%rax;"                                           \
                   "vmcall;"                                                   \
                   "movq %%rax, %0;"                                           \
                   : "=a"(_rax)                                                \
                   : "r"(_rcx), "r"(_rbx), "r"(_rax)                           \
                   : "rcx", "rbx");                                            \
    } while (0);                                                               \
    _rax;                                                                      \
  })

static inline uint64_t kAFL_hypercall(uint64_t rbx, uint64_t rcx) {
  return KAFL_HYPERCALL_PT(rbx, rcx);
}

static inline void hprintf(const char *fmt, ...) {
  // return;
  char buf[BUFSIZ] = {'\0'};
  va_list ap;
  va_start(ap, fmt);
  vsnprintf(buf, BUFSIZ, fmt, ap);
  va_end(ap);
  kAFL_hypercall(HYPERCALL_KAFL_PRINTF, (uintptr_t)buf);
}

static inline void LogEnter(const char *str) { hprintf("Enter %s\n", str); }