TERMUX_PKG_HOMEPAGE=https://valgrind.org/
TERMUX_PKG_DESCRIPTION="Instrumentation framework for building dynamic analysis tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.22.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://sourceware.org/pub/valgrind/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c811db5add2c5f729944caf47c4e7a65dcaabb9461e472b578765dd7bf6d2d4c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="binutils-cross"
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
		# ```
		# <inline asm>:1:41: error: expected '%<type>' or "<type>"
		# .pushsection ".debug_gdb_scripts", "MS",@progbits,1
		#                                         ^
		# ```
		# See also https://github.com/llvm/llvm-project/issues/24438.
		termux_setup_no_integrated_as
	fi

	autoreconf -fi
}
