TERMUX_PKG_HOMEPAGE=https://valgrind.org/
TERMUX_PKG_DESCRIPTION="Instrumentation framework for building dynamic analysis tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.18.1
TERMUX_PKG_SRCURL=ftp://sourceware.org/pub/valgrind/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=00859aa13a772eddf7822225f4b46ee0d39afbe071d32778da4d99984081f7f5
TERMUX_PKG_BREAKS="valgrind-dev"
TERMUX_PKG_REPLACES="valgrind-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tmpdir=$TERMUX_PREFIX/tmp"

termux_step_pre_configure() {
	CFLAGS=${CFLAGS/-fstack-protector-strong/}

	if [ "$TERMUX_ARCH" == "aarch64" ]; then
		cp $TERMUX_PKG_BUILDER_DIR/aarch64-setjmp.S $TERMUX_PKG_SRCDIR
		patch --silent -p1 < $TERMUX_PKG_BUILDER_DIR/coregrindmake.am.diff
		patch --silent -p1 < $TERMUX_PKG_BUILDER_DIR/memcheckmake.am.diff
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --enable-only64bit"
	elif [ "$TERMUX_ARCH" == "arm" ]; then
		# valgrind doesn't like arm; armv7 works, though.
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --host=armv7-linux-androideabi"
		# http://lists.busybox.net/pipermail/buildroot/2013-November/082270.html:
		# "valgrind uses inline assembly that is not Thumb compatible":
		CFLAGS=${CFLAGS/-mthumb/}
	fi

	autoreconf -fi
}

termux_step_post_massage() {
	termux_download https://github.com/Lzhiyong/termux-ndk/raw/902f483485b4/patches/align_fix.py \
		$TERMUX_PKG_CACHEDIR/align_fix.py \
		83579beef5f0899300b2f1cb7cfad25c3ee2c90089f9b7eb83ce7472d0e730bd
	python3 $TERMUX_PKG_CACHEDIR/align_fix.py bin/valgrind
}
