/*
 * Copyright (C) 2012 The Android Open Source Project
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
#include <dlfcn.h>
#include <errno.h>
#include <execinfo.h>
#include <fcntl.h>
#include <inttypes.h>
#include <paths.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <unwind.h>

#if defined(__ANDROID__) && __ANDROID_API__ < 30
#define memfd_create(name,flags) syscall(SYS_memfd_create,name,flags)
#endif
#ifndef MFD_CLOEXEC
#define MFD_CLOEXEC 0x0001U
#endif

static inline int __tmpfile_crate() {
  char name[] = _PATH_TMP ".backtrace-FFFFFFFF-XXXXXXXX";
  snprintf(name, sizeof(name), _PATH_TMP ".backtrace-%0x-XXXXXXXX", getpid() & 0xFFFFFFFF);
  // XXX: It is almost impossible to have file conflicts, isn't it?
  int fd = mkstemp(name);
  unlink(name);
  return fd;
}

struct StackState {
  void** frames;
  int frame_count;
  int cur_frame;
};

static _Unwind_Reason_Code TraceFunction(struct _Unwind_Context* context, void* arg) {
  // The instruction pointer is pointing at the instruction after the return
  // call on all architectures.
  // Modify the pc to point at the real function.
  uintptr_t ip = _Unwind_GetIP(context);
  if (ip != 0) {
#if defined(__arm__)
    // If the ip is suspiciously low, do nothing to avoid a segfault trying
    // to access this memory.
    if (ip >= 4096) {
      // Check bits [15:11] of the first halfword assuming the instruction
      // is 32 bits long. If the bits are any of these values, then our
      // assumption was correct:
      //  b11101
      //  b11110
      //  b11111
      // Otherwise, this is a 16 bit instruction.
      uint16_t value = (*((uint16_t*)(ip - 2))) >> 11;
      if (value == 0x1f || value == 0x1e || value == 0x1d) {
        ip -= 4;
      } else {
        ip -= 2;
      }
    }
#elif defined(__aarch64__)
    // All instructions are 4 bytes long, skip back one instruction.
    ip -= 4;
#elif defined(__i386__) || defined(__x86_64__)
    // It's difficult to decode exactly where the previous instruction is,
    // so subtract 1 to estimate where the instruction lives.
    ip--;
#endif
  }
  struct StackState* state = (struct StackState*)(arg);
  state->frames[state->cur_frame++] = (void*)(ip);
  return (state->cur_frame >= state->frame_count) ? _URC_END_OF_STACK : _URC_NO_REASON;
}

int backtrace(void** buffer, int size) {
  if (size <= 0) {
    return 0;
  }
  struct StackState state = {buffer, size, 0};
  _Unwind_Backtrace(TraceFunction, &state);
  return state.cur_frame;
}

char** backtrace_symbols(void* const* buffer, int size) {
  if (size <= 0) {
    return NULL;
  }
  // Do this calculation first in case the user passes in a bad value.
  size_t ptr_size;
  if (__builtin_mul_overflow(sizeof(char*), size, &ptr_size)) {
    return NULL;
  }
  int fd = memfd_create("backtrace_symbols_fd", MFD_CLOEXEC);
  if (fd == -1) fd = __tmpfile_crate();
  if (fd == -1) {
    return NULL;
  }
  backtrace_symbols_fd(buffer, size, fd);
  // Get the size of the file.
  off_t file_size = lseek(fd, 0, SEEK_END);
  if (file_size <= 0) {
    close(fd);
    return NULL;
  }
  // The interface for backtrace_symbols indicates that only the single
  // returned pointer must be freed by the caller. Therefore, allocate a
  // buffer that includes the memory for the strings and all of the pointers.
  // Add one byte at the end just in case the file didn't end with a '\n'.
  size_t symbol_data_size;
  if (__builtin_add_overflow(ptr_size, file_size, &symbol_data_size) ||
      __builtin_add_overflow(symbol_data_size, 1, &symbol_data_size)) {
    close(fd);
    return NULL;
  }
  uint8_t* symbol_data = (uint8_t*)(malloc(symbol_data_size));
  if (symbol_data == NULL) {
    close(fd);
    return NULL;
  }
  // Copy the string data into the buffer.
  char* cur_string = (char*)(&symbol_data[ptr_size]);
  // If this fails, the read won't read back the correct number of bytes.
  lseek(fd, 0, SEEK_SET);
  ssize_t num_read = read(fd, cur_string, file_size);
  close(fd);
  fd = -1;
  if (num_read != file_size) {
    free(symbol_data);
    return NULL;
  }
  // Make sure the last character in the file is '\n'.
  if (cur_string[file_size] != '\n') {
    cur_string[file_size++] = '\n';
  }
  for (int i = 0; i < size; i++) {
    ((char**)(symbol_data))[i] = cur_string;
    cur_string = strchr(cur_string, '\n');
    if (cur_string == NULL) {
      free(symbol_data);
      return NULL;
    }
    cur_string[0] = '\0';
    cur_string++;
  }
  return (char**)(symbol_data);
}

// This function should do no allocations if possible.
void backtrace_symbols_fd(void* const* buffer, int size, int fd) {
  if (size <= 0 || fd < 0) {
    return;
  }
  for (int frame_num = 0; frame_num < size; frame_num++) {
    void* address = buffer[frame_num];
    Dl_info info;
    if (dladdr(address, &info) != 0) {
      if (info.dli_fname != NULL) {
        write(fd, info.dli_fname, strlen(info.dli_fname));
      }
      if (info.dli_sname != NULL) {
        dprintf(fd, "(%s+0x%" PRIxPTR ") ", info.dli_sname,
                (uintptr_t)(address) - (uintptr_t)(info.dli_saddr));
      } else {
        dprintf(fd, "(+%p) ", info.dli_saddr);
      }
    }
    dprintf(fd, "[%p]\n", address);
  }
}
