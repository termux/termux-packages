/*
 * Copyright (C) 2017 The Android Open Source Project
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

#ifndef _SPAWN_H_
#define _SPAWN_H_

#include <sys/cdefs.h>
#include <sys/types.h>
#include <sched.h>
#include <signal.h>

__BEGIN_DECLS

#define POSIX_SPAWN_RESETIDS 1
#define POSIX_SPAWN_SETPGROUP 2
#define POSIX_SPAWN_SETSIGDEF 4
#define POSIX_SPAWN_SETSIGMASK 8
#define POSIX_SPAWN_SETSCHEDPARAM 16
#define POSIX_SPAWN_SETSCHEDULER 32
#if defined(__USE_GNU)
#define POSIX_SPAWN_USEVFORK 64
#define POSIX_SPAWN_SETSID 128
#endif

typedef struct __posix_spawnattr* posix_spawnattr_t;
typedef struct __posix_spawn_file_actions* posix_spawn_file_actions_t;

int posix_spawn(pid_t* __pid, const char* __path, const posix_spawn_file_actions_t* __actions, const posix_spawnattr_t* __attr, char* const __argv[], char* const __env[]) __INTRODUCED_IN(28);
int posix_spawnp(pid_t* __pid, const char* __file, const posix_spawn_file_actions_t* __actions, const posix_spawnattr_t* __attr, char* const __argv[], char* const __env[]) __INTRODUCED_IN(28);

int posix_spawnattr_init(posix_spawnattr_t* __attr) __INTRODUCED_IN(28);
int posix_spawnattr_destroy(posix_spawnattr_t* __attr) __INTRODUCED_IN(28);

int posix_spawnattr_setflags(posix_spawnattr_t* __attr, short __flags) __INTRODUCED_IN(28);
int posix_spawnattr_getflags(const posix_spawnattr_t* __attr, short* __flags) __INTRODUCED_IN(28);

int posix_spawnattr_setpgroup(posix_spawnattr_t* __attr, pid_t __pgroup) __INTRODUCED_IN(28);
int posix_spawnattr_getpgroup(const posix_spawnattr_t* __attr, pid_t* __pgroup) __INTRODUCED_IN(28);

int posix_spawnattr_setsigmask(posix_spawnattr_t* __attr, const sigset_t* __mask) __INTRODUCED_IN(28);
int posix_spawnattr_setsigmask64(posix_spawnattr_t* __attr, const sigset64_t* __mask) __INTRODUCED_IN(28);
int posix_spawnattr_getsigmask(const posix_spawnattr_t* __attr, sigset_t* __mask) __INTRODUCED_IN(28);
int posix_spawnattr_getsigmask64(const posix_spawnattr_t* __attr, sigset64_t* __mask) __INTRODUCED_IN(28);

int posix_spawnattr_setsigdefault(posix_spawnattr_t* __attr, const sigset_t* __mask) __INTRODUCED_IN(28);
int posix_spawnattr_setsigdefault64(posix_spawnattr_t* __attr, const sigset64_t* __mask) __INTRODUCED_IN(28);
int posix_spawnattr_getsigdefault(const posix_spawnattr_t* __attr, sigset_t* __mask) __INTRODUCED_IN(28);
int posix_spawnattr_getsigdefault64(const posix_spawnattr_t* __attr, sigset64_t* __mask) __INTRODUCED_IN(28);

int posix_spawnattr_setschedparam(posix_spawnattr_t* __attr, const struct sched_param* __param) __INTRODUCED_IN(28);
int posix_spawnattr_getschedparam(const posix_spawnattr_t* __attr, struct sched_param* __param) __INTRODUCED_IN(28);

int posix_spawnattr_setschedpolicy(posix_spawnattr_t* __attr, int __policy) __INTRODUCED_IN(28);
int posix_spawnattr_getschedpolicy(const posix_spawnattr_t* __attr, int* __policy) __INTRODUCED_IN(28);

int posix_spawn_file_actions_init(posix_spawn_file_actions_t* __actions) __INTRODUCED_IN(28);
int posix_spawn_file_actions_destroy(posix_spawn_file_actions_t* __actions) __INTRODUCED_IN(28);

int posix_spawn_file_actions_addopen(posix_spawn_file_actions_t* __actions, int __fd, const char* __path, int __flags, mode_t __mode) __INTRODUCED_IN(28);
int posix_spawn_file_actions_addclose(posix_spawn_file_actions_t* __actions, int __fd) __INTRODUCED_IN(28);
int posix_spawn_file_actions_adddup2(posix_spawn_file_actions_t* __actions, int __fd, int __new_fd) __INTRODUCED_IN(28);

__END_DECLS

#endif
