TERMUX_PKG_HOMEPAGE=https://codeberg.org/ifreund/zig-wayland
TERMUX_PKG_DESCRIPTION="Zig wayland scanner and libwayland bindings"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.0
TERMUX_PKG_SRCURL="https://codeberg.org/ifreund/zig-wayland/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=c54f08ac44d214e28a410320c15c9128bc0669e93851268a5e0e3d4bda074934
TERMUX_PKG_DEPENDS="libwayland"

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
