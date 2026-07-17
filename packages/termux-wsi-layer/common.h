/*
 * Copyright (c) 2024 Twaik Yont <twaikyont@gmail.com>
 *
 * Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * https://www.gnu.org/licenses/gpl-3.0.en.html
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#pragma once

// Workaround for `error: 'AHardwareBuffer_describe' is unavailable: introduced in Android 26`
// We will explicitly mark these symbols as weak to avoid using `ANDROID_UNAVAILABLE_SYMBOLS_ARE_WEAK`
// These symbols will equal to NULL in the case if they were not linked and we can check this in __eglMain
#define AHardwareBuffer_allocate _AHardwareBuffer_allocate
#define AHardwareBuffer_release _AHardwareBuffer_release
#define AHardwareBuffer_describe _AHardwareBuffer_describe
#define AHardwareBuffer_sendHandleToUnixSocket _AHardwareBuffer_sendHandleToUnixSocket
#include <android/hardware_buffer.h>
#undef AHardwareBuffer_allocate
#undef AHardwareBuffer_release
#undef AHardwareBuffer_describe
#undef AHardwareBuffer_sendHandleToUnixSocket

#define WEAK __attribute__((weak))
int AHardwareBuffer_allocate(const AHardwareBuffer_Desc* _Nonnull desc, AHardwareBuffer* _Nullable* _Nonnull outBuffer) WEAK;
void AHardwareBuffer_release(AHardwareBuffer* _Nonnull buffer) WEAK;
void AHardwareBuffer_describe(const AHardwareBuffer* _Nonnull buffer, AHardwareBuffer_Desc* _Nonnull outDesc) WEAK;
int AHardwareBuffer_sendHandleToUnixSocket(const AHardwareBuffer* _Nonnull buffer, int socketFd) WEAK;

// We can not link to these functions directly for two reasons
// 1. This API is not exposed to NDK.
// 2. The `libui.so` is explicitly blocklisted for linking.
// So our solution is to declare these symbols as weak and let linker override them.
// We use GraphicBuffer_getNativeBuffer only as fallback in the case if AHardwareBuffer_to_ANativeWindowBuffer is unavailable.
// Both AHardwareBuffer_to_ANativeWindowBuffer and GraphicBuffer_getNativeBuffer are aliases to make code easier to read.

#define AHardwareBuffer_to_ANativeWindowBuffer _ZN7android38AHardwareBuffer_to_ANativeWindowBufferEP15AHardwareBuffer
#define GraphicBuffer_getNativeBuffer _ZNK7android13GraphicBuffer15getNativeBufferEv
size_t AHardwareBuffer_to_ANativeWindowBuffer(void* _Nullable) WEAK;
size_t GraphicBuffer_getNativeBuffer(void* _Nullable) WEAK;