TERMUX_PKG_HOMEPAGE=https://musl.libc.org/
TERMUX_PKG_DESCRIPTION="Compatibility headers for musl (sys/queue.h and sys/cdefs.h)"
TERMUX_PKG_LICENSE="BSD-3-Clause, Public Domain"
TERMUX_PKG_LICENSE_FILE=""  # No source to extract license from
TERMUX_PKG_MAINTAINER="@codingWiz-rick"
TERMUX_PKG_VERSION="1.0"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	local QUEUE_URL="https://raw.githubusercontent.com/NetBSD/src/03be82a6b173b3c62116b7a186067fed3004dd44/sys/sys/queue.h"
	
	mkdir -p $TERMUX_PREFIX/opt/musl/include/sys
	
	curl -L -o $TERMUX_PREFIX/opt/musl/include/sys/queue.h "$QUEUE_URL"
	
	cat > $TERMUX_PREFIX/opt/musl/include/sys/cdefs.h <<'CDEFS'
#ifndef BUILDROOT_SYS_CDEFS_H
#define BUILDROOT_SYS_CDEFS_H

#undef __P
#define __P(arg) arg

#ifdef __cplusplus
# define __BEGIN_DECLS extern "C" {
# define __END_DECLS   }
#else
# define __BEGIN_DECLS
# define __END_DECLS
#endif

#ifndef __cplusplus
# define __THROW  __attribute__ ((__nothrow__))
# define __NTH(f) __attribute__ ((__nothrow__)) f
#else
# define __THROW
# define __NTH(f) f
#endif

#endif
CDEFS
	
	chmod 644 $TERMUX_PREFIX/opt/musl/include/sys/queue.h
	chmod 644 $TERMUX_PREFIX/opt/musl/include/sys/cdefs.h
	
	# Create a LICENSE file for the package
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	cat > $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE <<'LICENSE'
This package contains compatibility headers from different sources:

1. sys/queue.h - BSD-3-Clause License (from NetBSD)
   Copyright (c) 1991, 1993 The Regents of the University of California.
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:
   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
   3. Neither the name of the University nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS" AND
   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED.

2. sys/cdefs.h - Public Domain (custom implementation)
LICENSE
}
