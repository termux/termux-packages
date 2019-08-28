/*
 * dhcpcd - DHCP client daemon
 * Copyright (c) 2006-2012 Roy Marples <roy@marples.name>
 * All rights reserved

 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */

#ifndef POSIX_SPAWN_H
#define POSIX_SPAWN_H

#include <signal.h>

typedef struct {
	short posix_attr_flags;
#define POSIX_SPAWN_SETSIGDEF		0x10
#define POSIX_SPAWN_SETSIGMASK		0x20
	sigset_t posix_attr_sigmask;
	sigset_t posix_attr_sigdefault;
} posix_spawnattr_t;

typedef struct {
//	int unused;
} posix_spawn_file_actions_t;

int posix_spawn(pid_t *, const char *,
    const posix_spawn_file_actions_t *, const posix_spawnattr_t *,
    char *const [], char *const []);
int posix_spawnattr_init(posix_spawnattr_t *);
int posix_spawnattr_setflags(posix_spawnattr_t *, short);
int posix_spawnattr_setsigmask(posix_spawnattr_t *, const sigset_t *);
int posix_spawnattr_setsigdefault(posix_spawnattr_t *, const sigset_t *);

#endif
