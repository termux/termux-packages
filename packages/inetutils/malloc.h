// XXX: For some reasons, struct FILE is not properly declared in inetutils's wrapper of <stdlib.h>.
// XXX: Add a wrapper of <malloc.h> to avoid the following error.
// In file included from /home/builder/.termux-build/inetutils/src/lib/argp-eexst.c:25:
// In file included from /home/builder/.termux-build/inetutils/src/lib/argp.h:22:
// In file included from ./stdio.h:43:
// In file included from /home/builder/.termux-build/_cache/android-r23c-api-24-v0/bin/../sysroot/usr/include/stdio.h:47:
// In file included from ./string.h:52:
// In file included from ./stdlib.h:36:
// In file included from /home/builder/.termux-build/_cache/android-r23c-api-24-v0/bin/../sysroot/usr/include/stdlib.h:34:
// /home/builder/.termux-build/_cache/android-r23c-api-24-v0/bin/../sysroot/usr/include/malloc.h:168:37: error: unknown type name 'FILE'

#pragma once
struct __sFILE;
typedef struct __sFILE FILE;
#include_next <malloc.h>
