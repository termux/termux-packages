TERMUX_PKG_HOMEPAGE=https://uftrace.github.io/slide
TERMUX_PKG_DESCRIPTION="Function (graph) tracer for user-space"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.4
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/namhyung/uftrace/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=418d30c959d3b6d0dcafd55e588a5d414a9984b30f2522a5af004a268824a5a2
TERMUX_PKG_DEPENDS="capstone, libandroid-glob, libandroid-spawn, libelf, libdw, ncurses, python"
TERMUX_PKG_BUILD_DEPENDS="argp"

termux_step_pre_configure() {
	# uftrace uses custom configure script implementation, so we need to provide some flags
	export CFLAGS="${CFLAGS} -I${TERMUX_PREFIX}/include -I${TERMUX_PREFIX}/include/python3.10 -DEFD_SEMAPHORE=1 -DEF_ARM_ABI_FLOAT_HARD=0x400 -w"
	export LDFLAGS="${LDFLAGS} -Wl,--wrap=_Unwind_Resume -landroid-glob -largp -lpython3.10"

	if [ "$TERMUX_ARCH" = "i686" ]; then
		export ARCH="i386"
	else
		export ARCH="$TERMUX_ARCH"
	fi
}
