TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/grep/
TERMUX_PKG_DESCRIPTION="Command which searches one or more input files for lines containing a match to a specified pattern"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/grep/grep-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=667e15e8afe189e93f9f21a7cd3a7b3f776202f417330b248c2ad4f997d9373e
TERMUX_PKG_DEPENDS="libandroid-support, pcre"
TERMUX_PKG_ESSENTIAL=true

termux_step_pre_configure() {
	if $TERMUX_DEBUG; then
		# When doing debug build, -D_FORTIFY_SOURCE=2 gives this error:
		# /home/builder/.termux-build/_cache/19b-aarch64-24-v5/bin/../sysroot/usr/include/bits/fortify/stdio.h:51:53: error: use of undeclared identifier '__USE_FORTIFY_LEVEL'
		# return __builtin___vsnprintf_chk(dest, size, 0, __bos(dest), format, ap);
		#                                                 ^
		# lib/cdefs.h:123:48: note: expanded from macro '__bos'
		# #define __bos(ptr) __builtin_object_size (ptr, __USE_FORTIFY_LEVEL > 1)
		#                                                ^
		export CFLAGS=${CFLAGS/-D_FORTIFY_SOURCE=2/}
	fi
}
