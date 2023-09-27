/*
 * Copyright (C) 2014 The Android Open Source Project
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

#ifndef _SYS_SEM_H_
#define _SYS_SEM_H_

#include <sys/cdefs.h>
#include <sys/ipc.h>
#include <sys/types.h>

#if defined(__USE_GNU)
#include <bits/timespec.h>
#endif

#include <linux/sem.h>

__BEGIN_DECLS

#define semid_ds semid64_ds

union semun {
  int val;
  struct semid_ds* buf;
  unsigned short* array;
  struct seminfo* __buf;
  void* __pad;
};


#undef semctl
#define semctl libandroid_semctl
int semctl(int __sem_id, int __sem_num, int __cmd, ...);
#undef semget
#define semget libandroid_semget
int semget(key_t __key, int __sem_count, int __flags);
#undef semop
#define semop libandroid_semop
int semop(int __sem_id, struct sembuf* __ops, size_t __op_count);


#if defined(__USE_GNU)

#undef semtimedop
#define semtimedop libandroid_semtimedop
int semtimedop(int __sem_id, struct sembuf* __ops, size_t __op_count, const struct timespec* __timeout);

#endif

__END_DECLS

#endif
