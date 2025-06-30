TERMUX_PKG_HOMEPAGE=https://oneapi-src.github.io/oneTBB/
TERMUX_PKG_DESCRIPTION="oneAPI Threading Building Blocks"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2022.2.0"
TERMUX_PKG_SRCURL=https://github.com/oneapi-src/oneTBB/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0f78001c8c8edb4bddc3d4c5ee7428d56ae313254158ad1eec49eced57f6a5b
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
