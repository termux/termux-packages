TERMUX_PKG_HOMEPAGE=https://valgrind.org/
TERMUX_PKG_DESCRIPTION="Instrumentation framework for building dynamic analysis tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.28.0"
TERMUX_PKG_SRCURL=http://sourceware.org/pub/valgrind/valgrind-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=9f7a18d128f05d3a80fea53e6953f34aad7200a425ceaee46099a8a798a7dd9c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_DEPENDS="binutils-cross"
TERMUX_PKG_BREAKS="valgrind-dev"
TERMUX_PKG_REPLACES="valgrind-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-tmpdir=$TERMUX_PREFIX/tmp"
TERMUX_PKG_UNDEF_SYMBOLS_FILES="./libexec/valgrind/vgpreload_*.so"

termux_step_pre_configure() {
	CFLAGS=${CFLAGS/-fstack-protector-strong/}

	if [ "$TERMUX_ARCH" == "aarch64" ]; then
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

termux_step_post_make_install() {
	cat >> "$TERMUX_PREFIX/libexec/valgrind/default.supp" <<-EOF

	{
		termux-bionic-linker-cond
		Memcheck:Cond
		obj:*/bin/linker*
	}
	{
		termux-bionic-linker-value4
		Memcheck:Value4
		obj:*/bin/linker*
	}
	{
		termux-bionic-linker-value8
		Memcheck:Value8
		obj:*/bin/linker*
	}
	{
		termux-bionic-clone-tlsinfo
		Memcheck:Param
		clone(tlsinfo)
		fun:__bionic_clone
	}
	EOF
}
