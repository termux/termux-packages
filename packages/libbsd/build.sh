TERMUX_PKG_HOMEPAGE=https://libbsd.freedesktop.org
TERMUX_PKG_DESCRIPTION="utility functions from BSD systems"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.7"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://libbsd.freedesktop.org/releases/libbsd-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=9baa186059ebbf25c06308e9f991fda31f7183c0f24931826d83aa6abd8a0261
TERMUX_PKG_DEPENDS="libmd"
TERMUX_PKG_BREAKS="libbsd-dev"
TERMUX_PKG_REPLACES="libbsd-dev"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# Fix linker script error
	LDFLAGS+=" -Wl,--undefined-version"
}
