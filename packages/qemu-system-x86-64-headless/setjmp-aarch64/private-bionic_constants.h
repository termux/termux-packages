/*
 * Copyright (C) 2014 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _BIONIC_CONSTANTS_H_
#define _BIONIC_CONSTANTS_H_

#define NS_PER_S 1000000000

// Size of the shadow call stack. This must be a power of 2.
#define SCS_SIZE (8 * 1024)

// The shadow call stack is allocated at an aligned address within a guard region of this size. The
// guard region must be large enough that we can allocate an SCS_SIZE-aligned SCS while ensuring
// that there is at least one guard page after the SCS so that a stack overflow results in a SIGSEGV
// instead of corrupting the allocation that comes after it.
#define SCS_GUARD_REGION_SIZE (16 * 1024 * 1024)

#endif // _BIONIC_CONSTANTS_H_
