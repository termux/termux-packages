TERMUX_PKG_HOMEPAGE=http://valgrind.org/
TERMUX_PKG_DESCRIPTION="Instrumentation framework for building dynamic analysis tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.14.0
TERMUX_PKG_SHA256=037c11bfefd477cc6e9ebe8f193bb237fe397f7ce791b4a4ce3fa1c6a520baa5
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/valgrind/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tmpdir=$TERMUX_PREFIX/tmp"
# - Does not build on x86_64 due to lacking upstream support of that arch on android.
#   https://bugs.kde.org/show_bug.cgi?id=348342
# - Does not build on aarch64 using clang, fails with
#   "`__builtin_longjmp is not supported for the current target"
#   https://bugs.kde.org/show_bug.cgi?id=369723
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_pre_configure() {
	if [ "$TERMUX_ARCH" == "aarch64" ]; then
		cp $TERMUX_PKG_BUILDER_DIR/aarch64-setjmp.S $TERMUX_PKG_SRCDIR
		autoreconf -if
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-only64bit"
	fi
	if [ "$TERMUX_ARCH" == "arm" ]; then
		# valgrind doesn't like arm; armv7 works, though.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --host=armv7-linux-androideabi"
		# http://lists.busybox.net/pipermail/buildroot/2013-November/082270.html:
		# "valgrind uses inline assembly that is not Thumb compatible":
		CFLAGS=${CFLAGS/-mthumb/}
	fi
	if [ "$TERMUX_DEBUG" == "true" ]; then
		CFLAGS=${CFLAGS/-fstack-protector/}
	fi
}
