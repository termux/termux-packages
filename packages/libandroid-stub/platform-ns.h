#ifndef PLATFORM_NS_H
#define PLATFORM_NS_H

/* dlopen(3) for an Android platform library.
 *
 * Termux installs libraries whose sonames collide with the platform ones
 * (liblzma.so, libz.so, ...), so loading a platform library the ordinary way
 * resolves its dependencies against $PREFIX/lib and fails. This loads it into
 * a linker namespace of its own instead: one that only searches the platform
 * directories and reaches the APEX libraries the way the platform does.
 *
 * The namespace is created once per process and shared by every caller, so
 * that a process never ends up with two copies of libbinder.so and thus two
 * ProcessState singletons. Where the linker does not let us have a namespace
 * this falls back to plain dlopen(3), i.e. to the behaviour of the wrappers
 * before namespaces were used at all.
 *
 * RTLD_GLOBAL keeps working: it applies within the namespace, which is what
 * makes it usable for simulating LD_PRELOAD of a platform library.
 *
 * https://source.android.com/docs/core/architecture/vndk/linker-namespace */

void *platform_dlopen(const char *path, int flags);

#endif
