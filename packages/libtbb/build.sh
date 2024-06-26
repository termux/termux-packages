TERMUX_PKG_HOMEPAGE=https://oneapi-src.github.io/oneTBB/
TERMUX_PKG_DESCRIPTION="oneAPI Threading Building Blocks"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2021.13.0"
TERMUX_PKG_SRCURL=https://github.com/oneapi-src/oneTBB/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3ad5dd08954b39d113dc5b3f8a8dc6dc1fd5250032b7c491eb07aed5c94133e1
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DTBB_STRICT=OFF
-DTBB_TEST=OFF
"

termux_step_pre_configure() {
	# Many symbols in the linker version scripts are undefined because link time
	# optimization (-flto=thin) removes them. Suppress errors with lld >= 17 due to
	# these undefined symbols.
	# See https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=274337
	LDFLAGS+=" -Wl,--undefined-version"
}
