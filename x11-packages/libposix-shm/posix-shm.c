//
// An implementation of shm_open(), shm_unlink() from the GNU C Library
//
// Copyright (C) 2001,2002,2005 Free Software Foundation, Inc.
// Copyright (C) 2018 Leonid Plyushch
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
//

#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifdef __ANDROID__
#define SHMDIR "/data/data/com.termux/files/usr/tmp/"
#else
#define SHMDIR "/dev/shm/"
#endif

int shm_open(const char *name, int oflag, mode_t mode) {
	size_t namelen;
	char *fname;
	int fd;

	/* Construct the filename.  */
	while (name[0] == '/') ++name;

	if (name[0] == '\0') {
		/* The name "/" is not supported.  */
		errno = EINVAL;
		return -1;
	}

	namelen = strlen(name);
	fname = (char *) alloca(sizeof(SHMDIR) - 1 + namelen + 1);
	memcpy(fname, SHMDIR, sizeof(SHMDIR) - 1);
	memcpy(fname + sizeof(SHMDIR) - 1, name, namelen + 1);

	fd = open(fname, oflag, mode);
	if (fd != -1) {
		/* We got a descriptor.  Now set the FD_CLOEXEC bit.  */
		int flags = fcntl(fd, F_GETFD, 0);
		flags |= FD_CLOEXEC;
		flags = fcntl(fd, F_SETFD, flags);

		if (flags == -1) {
			/* Something went wrong.  We cannot return the descriptor.  */
			int save_errno = errno;
			close(fd);
			fd = -1;
			errno = save_errno;
		}
	}

	return fd;
}

int shm_unlink(const char *name) {
	size_t namelen;
	char *fname;

	/* Construct the filename.  */
	while (name[0] == '/') ++name;

	if (name[0] == '\0') {
		/* The name "/" is not supported.  */
		errno = EINVAL;
		return -1;
	}

	namelen = strlen(name);
	fname = (char *) alloca(sizeof(SHMDIR) - 1 + namelen + 1);
	memcpy(fname, SHMDIR, sizeof(SHMDIR) - 1);
	memcpy(fname + sizeof(SHMDIR) - 1, name, namelen + 1);

	return unlink(fname);
}
