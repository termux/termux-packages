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

#include <private/bionic_asm.h>
#include <private/bionic_constants.h>

// According to AARCH64 PCS document we need to save the following
// registers:
//
// Core     x19 - x30, sp (see section 5.1.1)
// VFP      d8 - d15 (see section 5.1.2)
//
// NOTE: All the registers saved here will have 64 bit vales.
//       AAPCS mandates that the higher part of q registers do not need to
//       be saved by the callee.
//
// The internal structure of a jmp_buf is totally private.
// Current layout (changes from release to release):
//
// word   name            description
// 0      sigflag/cookie  setjmp cookie in top 31 bits, signal mask flag in low bit
// 1      sigmask         signal mask (not used with _setjmp / _longjmp)
// 2      core_base       base of core registers (x18-x30, sp)
//                        (We only store the low bits of x18 to avoid leaking the
//                        shadow call stack address into memory.)
// 16     float_base      base of float registers (d8-d15)
// 24     checksum        checksum of core registers
// 25     reserved        reserved entries (room to grow)
// 32

#define _JB_SIGFLAG     0
#define _JB_SIGMASK     (_JB_SIGFLAG + 1)
#define _JB_X30_SP      (_JB_SIGMASK + 1)
#define _JB_X28_X29     (_JB_X30_SP  + 2)
#define _JB_X26_X27     (_JB_X28_X29 + 2)
#define _JB_X24_X25     (_JB_X26_X27 + 2)
#define _JB_X22_X23     (_JB_X24_X25 + 2)
#define _JB_X20_X21     (_JB_X22_X23 + 2)
#define _JB_SCS_X19     (_JB_X20_X21 + 2)
#define _JB_D14_D15     (_JB_SCS_X19 + 2)
#define _JB_D12_D13     (_JB_D14_D15 + 2)
#define _JB_D10_D11     (_JB_D12_D13 + 2)
#define _JB_D8_D9       (_JB_D10_D11 + 2)
#define _JB_CHECKSUM    (_JB_D8_D9 + 2)

#define SCS_MASK (SCS_SIZE - 1)
#define MANGLE_REGISTERS 1
#define USE_CHECKSUM 1

.macro m_mangle_registers reg, sp_reg
#if MANGLE_REGISTERS
  eor x3, x3, \reg
  eor x19, x19, \reg
  eor x20, x20, \reg
  eor x21, x21, \reg
  eor x22, x22, \reg
  eor x23, x23, \reg
  eor x24, x24, \reg
  eor x25, x25, \reg
  eor x26, x26, \reg
  eor x27, x27, \reg
  eor x28, x28, \reg
  eor x29, x29, \reg
  eor x30, x30, \reg
  eor \sp_reg, \sp_reg, \reg
#endif
.endm

.macro m_calculate_checksum dst, src, scratch
  mov \dst, #0
  .irp i,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23
    ldr \scratch, [\src, #(\i * 8)]
    eor \dst, \dst, \scratch
  .endr
.endm

.macro m_unmangle_registers reg, sp_reg
  m_mangle_registers \reg, sp_reg=\sp_reg
.endm

ENTRY_PRIVATE(setjmp)
  mov w1, #1
  b sigsetjmp
END(setjmp)

ENTRY_PRIVATE(_setjmp)
  mov w1, #0
  b sigsetjmp
END(_setjmp)

// int sigsetjmp(sigjmp_buf env, int save_signal_mask);
ENTRY_PRIVATE(sigsetjmp)
  stp x0, x30, [sp, #-16]!
  .cfi_def_cfa_offset 16
  .cfi_rel_offset x0, 0
  .cfi_rel_offset x30, 8

  // Get the cookie and store it along with the signal flag.
  mov x0, x1
  //bl __bionic_setjmp_cookie_get
  mov x1, x0
  ldr x0, [sp, #0]
  str x1, [x0, #(_JB_SIGFLAG * 8)]

  // Do we need to save the signal mask?
  tbz w1, #0, 1f

  // Save the cookie for later.
  stp x1, xzr, [sp, #-16]!
  .cfi_adjust_cfa_offset 16

  // Save current signal mask.
  // The 'how' argument is ignored if new_mask is NULL.
  mov x1, #0 // NULL.
  add x2, x0, #(_JB_SIGMASK * 8) // old_mask.
  bl sigprocmask

  ldp x1, xzr, [sp], #16
  .cfi_adjust_cfa_offset -16

1:
  // Restore original x0 and lr.
  ldp x0, x30, [sp], #16
  .cfi_adjust_cfa_offset -16
  .cfi_restore x0
  .cfi_restore x30

  // Mask off the signal flag bit.
  bic x1, x1, #1

  // Mask off the high bits of the shadow call stack pointer.
  and x3, x18, #SCS_MASK

  // Save core registers.
  mov x10, sp
  m_mangle_registers x1, sp_reg=x10
  stp x30, x10, [x0, #(_JB_X30_SP  * 8)]
  stp x28, x29, [x0, #(_JB_X28_X29 * 8)]
  stp x26, x27, [x0, #(_JB_X26_X27 * 8)]
  stp x24, x25, [x0, #(_JB_X24_X25 * 8)]
  stp x22, x23, [x0, #(_JB_X22_X23 * 8)]
  stp x20, x21, [x0, #(_JB_X20_X21 * 8)]
  stp x3,  x19, [x0, #(_JB_SCS_X19 * 8)]
  m_unmangle_registers x1, sp_reg=x10

  // Save floating point registers.
  stp d14, d15, [x0, #(_JB_D14_D15 * 8)]
  stp d12, d13, [x0, #(_JB_D12_D13 * 8)]
  stp d10, d11, [x0, #(_JB_D10_D11 * 8)]
  stp d8,  d9,  [x0, #(_JB_D8_D9   * 8)]

#if USE_CHECKSUM
  // Calculate the checksum.
  m_calculate_checksum x12, x0, x2
  str x12, [x0, #(_JB_CHECKSUM * 8)]
#endif

  mov w0, #0
  ret
END(sigsetjmp)

// void siglongjmp(sigjmp_buf env, int value);
ENTRY_PRIVATE(siglongjmp)
#if USE_CHECKSUM
  // Check the checksum before doing anything.
  m_calculate_checksum x12, x0, x2
  ldr x2, [x0, #(_JB_CHECKSUM * 8)]

  cmp x2, x12
  //bne __bionic_setjmp_checksum_mismatch
#endif

#if __has_feature(hwaddress_sanitizer)
  stp x0, x30, [sp, #-16]!
  .cfi_adjust_cfa_offset 16
  .cfi_rel_offset x0, 0
  .cfi_rel_offset x30, 8
  mov x19, x1 // Save 'value'.

  // load and unmangle destination SP
  ldr x2, [x0, #(_JB_SIGFLAG * 8)]
  bic x2, x2, #1
  ldr x0, [x0, #(_JB_X30_SP  * 8 + 8)]
  eor x0, x0, x2
  bl __hwasan_handle_longjmp

  mov x1, x19 // Restore 'value'.
  // Restore original x0 and lr.
  ldp x0, x30, [sp], #16
  .cfi_adjust_cfa_offset -16
  .cfi_restore x0
  .cfi_restore x30
#endif

  // Do we need to restore the signal mask?
  ldr x2, [x0, #(_JB_SIGFLAG * 8)]
  tbz w2, #0, 1f

  stp x0, x30, [sp, #-16]!
  .cfi_adjust_cfa_offset 16
  .cfi_rel_offset x0, 0
  .cfi_rel_offset x30, 8

  // Restore signal mask.
  mov x19, x1 // Save 'value'.

  mov x2, x0
  mov x0, #2 // SIG_SETMASK
  add x1, x2, #(_JB_SIGMASK * 8) // new_mask.
  mov x2, #0 // NULL.
  bl sigprocmask
  mov x1, x19 // Restore 'value'.

  // Restore original x0 and lr.
  ldp x0, x30, [sp], #16
  .cfi_adjust_cfa_offset -16
  .cfi_restore x0
  .cfi_restore x30

  ldr x2, [x0, #(_JB_SIGFLAG * 8)]
1:
  // Restore core registers.
  bic x2, x2, #1
  ldp x30, x10, [x0, #(_JB_X30_SP  * 8)]
  ldp x28, x29, [x0, #(_JB_X28_X29 * 8)]
  ldp x26, x27, [x0, #(_JB_X26_X27 * 8)]
  ldp x24, x25, [x0, #(_JB_X24_X25 * 8)]
  ldp x22, x23, [x0, #(_JB_X22_X23 * 8)]
  ldp x20, x21, [x0, #(_JB_X20_X21 * 8)]
  ldp x3,  x19, [x0, #(_JB_SCS_X19 * 8)]
  m_unmangle_registers x2, sp_reg=x10
  mov sp, x10

  // Restore the low bits of the shadow call stack pointer.
  and x18, x18, #~SCS_MASK
  orr x18, x3, x18

  stp x0, x1, [sp, #-16]!
  .cfi_adjust_cfa_offset 16
  .cfi_rel_offset x0, 0
  .cfi_rel_offset x1, 8
  stp x30, xzr, [sp, #-16]!
  .cfi_adjust_cfa_offset 16
  .cfi_rel_offset x30, 0
  ldr x0, [x0, #(_JB_SIGFLAG * 8)]
  //bl __bionic_setjmp_cookie_check
  ldp x30, xzr, [sp], #16
  .cfi_adjust_cfa_offset -16
  .cfi_restore x30
  ldp x0, x1, [sp], #16
  .cfi_adjust_cfa_offset -16
  .cfi_restore x0
  .cfi_restore x1

  // Restore floating point registers.
  ldp d14, d15, [x0, #(_JB_D14_D15 * 8)]
  ldp d12, d13, [x0, #(_JB_D12_D13 * 8)]
  ldp d10, d11, [x0, #(_JB_D10_D11 * 8)]
  ldp d8,  d9,  [x0, #(_JB_D8_D9   * 8)]

  // Set return value.
  cmp w1, wzr
  csinc w0, w1, wzr, ne
  ret
END(siglongjmp)

ALIAS_SYMBOL(longjmp, siglongjmp)
.hidden longjmp
ALIAS_SYMBOL(_longjmp, siglongjmp)
.hidden _longjmp
