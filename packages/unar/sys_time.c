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

#include <sys/time.h>

#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>

#pragma GCC visibility push(hidden)

int timespec_from_timeval(struct timespec* ts, const struct timeval tv) {
  // Whole seconds can just be copied.
  ts->tv_sec = tv.tv_sec;

  // But we might overflow when converting microseconds to nanoseconds.
  if (tv.tv_usec >= 1000000 || tv.tv_usec < 0) {
    return 0;
  }
  ts->tv_nsec = tv.tv_usec * 1000;
  return 1;
}

static int futimesat(int fd, const char* path, const struct timeval tv[2], int flags) {
  struct timespec ts[2];
  if (tv && (!timespec_from_timeval(&ts[0], tv[0]) || !timespec_from_timeval(&ts[1], tv[1]))) {
    errno = EINVAL;
    return -1;
  }
  return utimensat(fd, path, tv ? ts : NULL, flags);
}

int lutimes(const char* path, const struct timeval tv[2]) {
  return futimesat(AT_FDCWD, path, tv, AT_SYMLINK_NOFOLLOW);
}

#pragma GCC visibility pop
