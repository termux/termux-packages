TERMUX_PKG_HOMEPAGE=https://codeberg.org/ifreund/zig-pixman
TERMUX_PKG_DESCRIPTION="Zig bindings for pixman"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.3.0
TERMUX_PKG_SRCURL="https://codeberg.org/ifreund/zig-pixman/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=cd7fe3415d4d58685a94fdedd308e9994a37f012828940cfb603461de7f2c6ad
TERMUX_PKG_DEPENDS="libpixman"

termux_step_pre_configure() {
	termux_setup_zig
	ZIG_PKG_HASH=$(zig fetch --global-cache-dir ${TERMUX_PKG_BUILDDIR} .)
}

termux_step_make_install() {
	install -m700 -d ${TERMUX_PREFIX}/lib/zig/packages/${ZIG_PKG_HASH}
	install -Dm600 -t ${TERMUX_PREFIX}/lib/zig/packages/${ZIG_PKG_HASH} \
		${TERMUX_PKG_BUILDDIR}/p/${ZIG_PKG_HASH}/*
}
