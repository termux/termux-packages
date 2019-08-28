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

/* This implementation of posix_spawn is only suitable for the needs of dhcpcd
 * but it could easily be extended to other applications. */

#include <sys/types.h>
#include <sys/wait.h>

#include <errno.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include "posix_spawn.h"

#ifndef _NSIG
#ifdef _SIG_MAXSIG
#define _NSIG _SIG_MAXSIG + 1
#else
/* Guess */
#define _NSIG SIGPWR + 1
#endif
#endif

extern char **environ;

static int
posix_spawnattr_handle(const posix_spawnattr_t *attrp)
{
	struct sigaction sa;
	int i;

	if (attrp->posix_attr_flags & POSIX_SPAWN_SETSIGMASK)
		sigprocmask(SIG_SETMASK, &attrp->posix_attr_sigmask, NULL);

	if (attrp->posix_attr_flags & POSIX_SPAWN_SETSIGDEF) {
		memset(&sa, 0, sizeof(sa));
		sa.sa_handler = SIG_DFL;
		for (i = 1; i < _NSIG; i++) {
			if (sigismember(&attrp->posix_attr_sigdefault, i)) {
				if (sigaction(i, &sa, NULL) == -1)
					return -1;
			}
		}
	}

	return 0;
}

inline static int
is_vfork_safe(short int flags)
{
	return !(flags & (POSIX_SPAWN_SETSIGDEF | POSIX_SPAWN_SETSIGMASK));
}

int
posix_spawn(pid_t *pid, const char *path,
	const posix_spawn_file_actions_t *file_actions,
	const posix_spawnattr_t *attrp,
	char *const argv[], char *const envp[])
{
	short int flags;
	pid_t p;
	volatile int error;

	error = 0;
	flags = attrp ? attrp->posix_attr_flags : 0;
	if (file_actions == NULL && is_vfork_safe(flags))
		p = vfork();
	else
#ifdef THERE_IS_NO_FORK
		return ENOSYS;
#else
		p = fork();
#endif
	switch (p) {
	case -1:
		return errno;
	case 0:
		if (attrp) {
			error = posix_spawnattr_handle(attrp);
			if (error)
				_exit(127);
		}
		execve(path, argv, envp);
		error = errno;
		_exit(127);
	default:
		if (error != 0)
			waitpid(p, NULL, WNOHANG);
		else if (pid != NULL)
			*pid = p;
		return error;
	}
}

int
posix_spawnattr_init(posix_spawnattr_t *attr)
{

	memset(attr, 0, sizeof(*attr));
	attr->posix_attr_flags = 0;
	sigprocmask(0, NULL, &attr->posix_attr_sigmask);
	sigemptyset(&attr->posix_attr_sigdefault);
	return 0;
}

int
posix_spawnattr_setflags(posix_spawnattr_t *attr, short flags)
{

	attr->posix_attr_flags = flags;
	return 0;
}

int
posix_spawnattr_setsigmask(posix_spawnattr_t *attr, const sigset_t *sigmask)
{

	attr->posix_attr_sigmask = *sigmask;
	return 0;
}

int
posix_spawnattr_setsigdefault(posix_spawnattr_t *attr, const sigset_t *sigmask)
{

	attr->posix_attr_sigdefault = *sigmask;
	return 0;
}
