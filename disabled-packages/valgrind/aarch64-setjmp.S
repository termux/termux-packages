/*
 * Copyright (C) 2013 The Android Open Source Project
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#ifdef __aarch64__

// Copied and simplified macros from bionic_asm.h.

#define ENTRY(f) \
    .text; \
    .globl f; \
    .type f, @function; \
    f: \
    .cfi_startproc \

#define END(f) \
    .cfi_endproc; \
    .size f, .-f; \

// According to AARCH64 PCS document we need to save the following
// registers:
//
// Core     x19 - x30, sp (see section 5.1.1)
// VFP      d8 - d15 (see section 5.1.2)
//
// NOTE: All the registers saved here will have 64 bit values.
//       AAPCS mandates that the higher part of q registers do not need to
//       be saved by the callee.
//
// The internal structure of a jmp_buf is totally private.
// Current layout (changes from release to release):
//
// word   name            description
// 0      sigflag/cookie  setjmp cookie in top 31 bits, signal mask flag in low bit
// 1      sigmask         signal mask (not used with _setjmp / _longjmp)
// 2      core_base       base of core registers (x19-x30, sp)
// 15     float_base      base of float registers (d8-d15)
// 23     checksum        checksum of core registers
// 24     reserved        reserved entries (room to grow)
// 32

// 'sigmask' and 'checksum' are not used in this simplified version for valgrind.

#define _JB_SIGFLAG     0
#define _JB_SIGMASK     (_JB_SIGFLAG + 1)
#define _JB_X30_SP      (_JB_SIGMASK + 1)
#define _JB_X28_X29     (_JB_X30_SP  + 2)
#define _JB_X26_X27     (_JB_X28_X29 + 2)
#define _JB_X24_X25     (_JB_X26_X27 + 2)
#define _JB_X22_X23     (_JB_X24_X25 + 2)
#define _JB_X20_X21     (_JB_X22_X23 + 2)
#define _JB_X19         (_JB_X20_X21 + 2)
#define _JB_D14_D15     (_JB_X19 + 1)
#define _JB_D12_D13     (_JB_D14_D15 + 2)
#define _JB_D10_D11     (_JB_D12_D13 + 2)
#define _JB_D8_D9       (_JB_D10_D11 + 2)

// int setjmp(jmp_buf env);
ENTRY(setjmp)
  // Save core registers.
  mov x10, sp
  stp x30, x10, [x0, #(_JB_X30_SP  * 8)]
  stp x28, x29, [x0, #(_JB_X28_X29 * 8)]
  stp x26, x27, [x0, #(_JB_X26_X27 * 8)]
  stp x24, x25, [x0, #(_JB_X24_X25 * 8)]
  stp x22, x23, [x0, #(_JB_X22_X23 * 8)]
  stp x20, x21, [x0, #(_JB_X20_X21 * 8)]
  str x19,      [x0, #(_JB_X19     * 8)]

  // Save floating point registers.
  stp d14, d15, [x0, #(_JB_D14_D15 * 8)]
  stp d12, d13, [x0, #(_JB_D12_D13 * 8)]
  stp d10, d11, [x0, #(_JB_D10_D11 * 8)]
  stp d8,  d9,  [x0, #(_JB_D8_D9   * 8)]

  mov w0, #0
  ret
END(setjmp)

// void longjmp(jmp_buf env, int value);
ENTRY(longjmp)
  // Restore core registers.
  ldp x30, x10, [x0, #(_JB_X30_SP  * 8)]
  ldp x28, x29, [x0, #(_JB_X28_X29 * 8)]
  ldp x26, x27, [x0, #(_JB_X26_X27 * 8)]
  ldp x24, x25, [x0, #(_JB_X24_X25 * 8)]
  ldp x22, x23, [x0, #(_JB_X22_X23 * 8)]
  ldp x20, x21, [x0, #(_JB_X20_X21 * 8)]
  ldr x19,      [x0, #(_JB_X19     * 8)]
  mov sp, x10

  // Restore floating point registers.
  ldp d14, d15, [x0, #(_JB_D14_D15 * 8)]
  ldp d12, d13, [x0, #(_JB_D12_D13 * 8)]
  ldp d10, d11, [x0, #(_JB_D10_D11 * 8)]
  ldp d8,  d9,  [x0, #(_JB_D8_D9   * 8)]

  // Set return value.
  cmp w1, wzr
  csinc w0, w1, wzr, ne
  ret
END(longjmp)

#endif  // __aarch64__
