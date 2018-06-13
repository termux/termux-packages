TERMUX_PKG_HOMEPAGE=http://valgrind.org/
TERMUX_PKG_DESCRIPTION="Instrumentation framework for building dynamic analysis tools"
TERMUX_PKG_VERSION=3.13.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/valgrind/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d76680ef03f00cd5e970bbdcd4e57fb1f6df7d2e2c071635ef2be74790190c3b
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tmpdir=$TERMUX_PREFIX/tmp"
# - Does not build on x86_64 due to lacking upstream support of that arch on android.
#   See https://bugs.kde.org/show_bug.cgi?id=348342
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"
# Fails on aarch64 with `__builtin_longjmp is not supported for the current target`
if [ $TERMUX_ARCH = aarch64 ]; then
       TERMUX_PKG_CLANG=no
fi

termux_step_pre_configure() {
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
