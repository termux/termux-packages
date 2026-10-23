TERMUX_PKG_HOMEPAGE=https://codeberg.org/ifreund/zig-xkbcommon
TERMUX_PKG_DESCRIPTION="Zig bindings for xkbcommon"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.0
TERMUX_PKG_SRCURL="https://codeberg.org/ifreund/zig-xkbcommon/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=1e185423e6b23ed9729614e66751ab7522db4487df4e0dcc7a2b06375aacda23
TERMUX_PKG_DEPENDS="libxkbcommon"

termux_step_pre_configure() {
	termux_setup_zig
	ZIG_PKG_HASH=$(zig fetch --global-cache-dir ${TERMUX_PKG_BUILDDIR} .)
}

termux_step_make_install() {
	install -Dm600 -t ${TERMUX_PREFIX}/lib/zig/packages/${ZIG_PKG_HASH} \
		${TERMUX_PKG_BUILDDIR}/p/${ZIG_PKG_HASH}/build.zig
	install -Dm600 -t ${TERMUX_PREFIX}/lib/zig/packages/${ZIG_PKG_HASH} \
		${TERMUX_PKG_BUILDDIR}/p/${ZIG_PKG_HASH}/build.zig.zon
	install -Dm600 -t ${TERMUX_PREFIX}/lib/zig/packages/${ZIG_PKG_HASH} \
		${TERMUX_PKG_BUILDDIR}/p/${ZIG_PKG_HASH}/LICENSE
	install -m700 -d ${TERMUX_PREFIX}/lib/zig/packages/${ZIG_PKG_HASH}/src
	install -Dm600 -t ${TERMUX_PREFIX}/lib/zig/packages/${ZIG_PKG_HASH}/src \
		${TERMUX_PKG_BUILDDIR}/p/${ZIG_PKG_HASH}/src/*
}
