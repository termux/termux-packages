/*
 * Copyright (C) 2016 The Android Open Source Project
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

#include <linux/sem.h>

#include <stdarg.h>
#include <sys/syscall.h>
#include <unistd.h>

#pragma GCC visibility push(hidden)

int semtimedop(int id, struct sembuf* ops, size_t op_count, const struct timespec* ts) {
#if defined(SYS_semtimedop)
  return syscall(SYS_semtimedop, id, ops, op_count, ts);
#else
  return syscall(SYS_ipc, SEMTIMEDOP, id, op_count, 0, ops, ts);
#endif
}

union semun {
  int val;
  struct semid_ds *buf;
  unsigned short *array;
} semu;

int semctl(int id, int num, int cmd, ...) {
#if !defined(__LP64__)
  // Annoyingly, the kernel requires this for 32-bit but rejects it for 64-bit.
  cmd |= IPC_64;
#endif
  va_list ap;
  va_start(ap, cmd);
  union semun arg = va_arg(ap, union semun);
  va_end(ap);
#if defined(SYS_semctl)
  return syscall(SYS_semctl, id, num, cmd, arg);
#else
  return syscall(SYS_ipc, SEMCTL, id, num, cmd, &arg, 0);
#endif
}

int semget(key_t key, int n, int flags) {
#if defined(SYS_semget)
  return syscall(SYS_semget, key, n, flags);
#else
  return syscall(SYS_ipc, SEMGET, key, n, flags, 0, 0);
#endif
}

int semop(int id, struct sembuf* ops, size_t op_count) {
  return semtimedop(id, ops, op_count, NULL);
}

#pragma GCC visibility pop
