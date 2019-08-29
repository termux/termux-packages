TERMUX_PKG_HOMEPAGE=https://uftrace.github.io/slide
TERMUX_PKG_DESCRIPTION="Function (graph) tracer for user-space"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=0.9.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/namhyung/uftrace/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d801d72e3cdd83c510aeecc5160482d879498cf08fffd21e64f84151001e18ea
TERMUX_PKG_DEPENDS="capstone, libandroid-glob, libandroid-spawn, libelf, ncurses, python2"
TERMUX_PKG_BUILD_DEPENDS="argp"

termux_step_pre_configure() {
	# uftrace uses custom configure script implementation, so we need to provide some flags
	export CFLAGS="${CFLAGS} -I${TERMUX_PREFIX}/include -DEFD_SEMAPHORE=1 -DEF_ARM_ABI_FLOAT_HARD=0x400 -w"
	export LDFLAGS="${LDFLAGS} -Wl,--wrap=_Unwind_Resume -landroid-glob -largp"

	if [ "$TERMUX_ARCH" = "i686" ]; then
		export ARCH="i386"
	else
		export ARCH="$TERMUX_ARCH"
	fi
}
