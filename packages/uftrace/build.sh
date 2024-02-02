TERMUX_PKG_HOMEPAGE=https://uftrace.github.io/slide
TERMUX_PKG_DESCRIPTION="Function (graph) tracer for user-space"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.2"
TERMUX_PKG_SRCURL=https://github.com/namhyung/uftrace/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f274437c59e845c7636be55267ea3e8f08b7ca11de2413b7045b403247d5f64d
# Hardcoded libpython${TERMUX_PYTHON_VERSION}.so is dlopen(3)ed by uftrace.
# Please revbump and rebuild when bumping TERMUX_PYTHON_VERSION.
# libandroid-{execinfo,spawn} are dlopen(3)ed.
TERMUX_PKG_DEPENDS="capstone, libandroid-execinfo, libandroid-glob, libandroid-spawn, libc++, libdw, libelf, libluajit, ncurses, python"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

# https://github.com/android/ndk/issues/1987#issuecomment-1886021103
if [ "$TERMUX_ARCH" = "x86_64" ]; then
	TERMUX_MAKE_PROCESSES=1
fi

termux_step_pre_configure() {
	# uftrace uses custom configure script implementation, so we need to provide some flags
	CFLAGS+=" -DEFD_SEMAPHORE=1 -DEF_ARM_ABI_FLOAT_HARD=0x400 -w"
	LDFLAGS+=" -Wl,--wrap=_Unwind_Resume -landroid-glob -largp"

	if [ "$TERMUX_ARCH" = "i686" ]; then
		export ARCH="i386"
	else
		export ARCH="$TERMUX_ARCH"
	fi
}
