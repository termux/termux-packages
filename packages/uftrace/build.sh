TERMUX_PKG_HOMEPAGE=https://uftrace.github.io/slide
TERMUX_PKG_DESCRIPTION="Function (graph) tracer for user-space"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.12"
TERMUX_PKG_SRCURL=https://github.com/namhyung/uftrace/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2aad01f27d4f18717b681824c7a28ac3e1efd5e7bbed3ec888a3ea5af60e3700
TERMUX_PKG_DEPENDS="capstone, libandroid-glob, libandroid-spawn, libelf, libdw, ncurses, python"
# On x86_64 utils/script-luajit.c:154:12 uses some sse2 feature even if sse2 is disabled.
# `error: sse2 register return with sse2 disabled`
[[ "${TERMUX_ARCH}" != "x86_64" ]] && TERMUX_PKG_DEPENDS+=", libluajit"
TERMUX_PKG_BUILD_DEPENDS="argp"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	# uftrace uses custom configure script implementation, so we need to provide some flags
	local _PYTHON_VERSION
	_PYTHON_VERSION=$(
		source $TERMUX_SCRIPTDIR/packages/python/build.sh
		echo $_MAJOR_VERSION
	)
	export CFLAGS="${CFLAGS} -I${TERMUX_PREFIX}/include -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION} -DEFD_SEMAPHORE=1 -DEF_ARM_ABI_FLOAT_HARD=0x400 -w"
	export LDFLAGS="${LDFLAGS} -Wl,--wrap=_Unwind_Resume -landroid-glob -largp -lpython${_PYTHON_VERSION}"

	if [ "$TERMUX_ARCH" = "i686" ]; then
		export ARCH="i386"
	else
		export ARCH="$TERMUX_ARCH"
	fi
}
