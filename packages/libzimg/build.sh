TERMUX_PKG_HOMEPAGE=https://github.com/sekrit-twc/zimg
TERMUX_PKG_DESCRIPTION="Scaling, colorspace conversion, and dithering library"
TERMUX_PKG_LICENSE="WTFPL"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.4
TERMUX_PKG_SRCURL=https://github.com/sekrit-twc/zimg/archive/release-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=219d1bc6b7fde1355d72c9b406ebd730a4aed9c21da779660f0a4c851243e32f
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
