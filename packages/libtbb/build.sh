TERMUX_PKG_HOMEPAGE=https://uxlfoundation.github.io/oneTBB/
TERMUX_PKG_DESCRIPTION="oneAPI Threading Building Blocks"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2023.2.0"
TERMUX_PKG_SRCURL=https://github.com/uxlfoundation/oneTBB/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=80cb62e62defeee67ea1885a6f72d97ac81404f8fde9cded62fb51524808a30c
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
