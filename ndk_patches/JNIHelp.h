/*
 * Copyright (C) 2007 The Android Open Source Project
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

/*
 * JNI helper functions.
 *
 * This file may be included by C or C++ code, which is trouble because jni.h
 * uses different typedefs for JNIEnv in each language.
 */
#ifndef _NATIVEHELPER_JNIHELP_H
#define _NATIVEHELPER_JNIHELP_H

#include "jni.h"
#include "utils/Log.h"

#ifndef NELEM
# define NELEM(x) ((int) (sizeof(x) / sizeof((x)[0])))
#endif

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Register one or more native methods with a particular class.
 */
int jniRegisterNativeMethods(C_JNIEnv* env, const char* className,
    const JNINativeMethod* gMethods, int numMethods);

/*
 * Throw an exception with the specified class and an optional message.
 * The "className" argument will be passed directly to FindClass, which
 * takes strings with slashes (e.g. "java/lang/Object").
 *
 * Returns 0 on success, nonzero if something failed (e.g. the exception
 * class couldn't be found).
 *
 * Currently aborts the VM if it can't throw the exception.
 */
int jniThrowException(C_JNIEnv* env, const char* className, const char* msg);

/*
 * Throw a java.lang.RuntimeException, with an optional message.
 */
int jniThrowRuntimeException(JNIEnv* env, const char* msg);

/*
 * Throw a java.io.IOException, generating the message from errno.
 */
int jniThrowIOException(C_JNIEnv* env, int errnum);

/*
 * Create a java.io.FileDescriptor given an integer fd
 */
jobject jniCreateFileDescriptor(C_JNIEnv* env, int fd);

/* 
 * Get an int file descriptor from a java.io.FileDescriptor
 */
int jniGetFDFromFileDescriptor(C_JNIEnv* env, jobject fileDescriptor);

/*
 * Set an int file descriptor to a java.io.FileDescriptor
 */
void jniSetFileDescriptorOfFD(C_JNIEnv* env, jobject fileDescriptor, int value);

#ifdef __cplusplus
}
#endif


/*
 * For C++ code, we provide inlines that map to the C functions.  g++ always
 * inlines these, even on non-optimized builds.
 */
#if defined(__cplusplus) && !defined(JNI_FORCE_C)
inline int jniRegisterNativeMethods(JNIEnv* env, const char* className,
    const JNINativeMethod* gMethods, int numMethods)
{
    return jniRegisterNativeMethods(&env->functions, className, gMethods,
        numMethods);
}
inline int jniThrowException(JNIEnv* env, const char* className,
    const char* msg)
{
    return jniThrowException(&env->functions, className, msg);
}
inline int jniThrowIOException(JNIEnv* env, int errnum)
{
    return jniThrowIOException(&env->functions, errnum);
}
inline jobject jniCreateFileDescriptor(JNIEnv* env, int fd)
{
    return jniCreateFileDescriptor(&env->functions, fd);
}
inline int jniGetFDFromFileDescriptor(JNIEnv* env, jobject fileDescriptor)
{
    return jniGetFDFromFileDescriptor(&env->functions, fileDescriptor);
}
inline void jniSetFileDescriptorOfFD(JNIEnv* env, jobject fileDescriptor,
    int value)
{
    return jniSetFileDescriptorOfFD(&env->functions, fileDescriptor, value);
}
#endif

#endif /*_NATIVEHELPER_JNIHELP_H*/
