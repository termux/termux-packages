/*
 * Copyright (C) 2021 The Android Open Source Project
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
#pragma once

#include <sys/cdefs.h>

/**
 * @file execinfo.h
 * @brief Functions to do in process backtracing.
 */

__BEGIN_DECLS

/**
 * [backtrace(3)](https://man7.org/linux/man-pages/man3/backtrace.3.html)
 * Saves a backtrace for the current call in the array pointed to by buffer.
 * "size" indicates the maximum number of void* pointers that can be set.
 *
 * Returns the number of addresses stored in "buffer", which is not greater
 * than "size". If the return value is equal to "size" then the number of
 * addresses may have been truncated.
 *
 * Available since API level 24.
 */
int backtrace(void** buffer, int size) __INTRODUCED_IN(24);

/**
 * [backtrace_symbols(3)](https://man7.org/linux/man-pages/man3/backtrace_symbols.3.html)
 * Given an array of void* pointers, translate the addresses into an array
 * of strings that represent the backtrace.
 *
 * Returns a pointer to allocated memory, on error NULL is returned. It is
 * the responsibility of the caller to free the returned memory.
 *
 * Available since API level 24.
 */
char** backtrace_symbols(void* const* buffer, int size) __INTRODUCED_IN(24);

/**
 * [backtrace_symbols_fd(3)](https://man7.org/linux/man-pages/man3/backtrace_symbols_fd.3.html)
 * Given an array of void* pointers, translate the addresses into an array
 * of strings that represent the backtrace and write to the file represented
 * by "fd". The file is written such that one line equals one void* address.
 *
 * Available since API level 24.
 */
void backtrace_symbols_fd(void* const* buffer, int size, int fd) __INTRODUCED_IN(24);

__END_DECLS
