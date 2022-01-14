TERMUX_PKG_HOMEPAGE=https://gpac.wp.imt.fr/
TERMUX_PKG_DESCRIPTION="An open-source multimedia framework focused on modularity and standards compliance"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=https://github.com/gpac/gpac/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3b0ffba73c68ea8847027c23f45cd81d705110ec47cf3c36f60e669de867e0af
TERMUX_PKG_DEPENDS="zlib"
TERMUX_PKG_EXTRA_MAKE_ARGS="STRIP=:"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-x11"

termux_step_pre_configure() {
	CFLAGS+=" -fPIC"
	for f in $CFLAGS $CPPFLAGS; do
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --extra-cflags=$f"
	done
	for f in $LDFLAGS; do
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --extra-ldflags=$f"
	done
}
