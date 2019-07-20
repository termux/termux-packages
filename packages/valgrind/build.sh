TERMUX_PKG_HOMEPAGE=http://valgrind.org/
TERMUX_PKG_DESCRIPTION="Instrumentation framework for building dynamic analysis tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.15.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SHA256=417c7a9da8f60dd05698b3a7bc6002e4ef996f14c13f0ff96679a16873e78ab1
TERMUX_PKG_BREAKS="valgrind-dev"
TERMUX_PKG_REPLACES="valgrind-dev"
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/valgrind/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tmpdir=$TERMUX_PREFIX/tmp"

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
