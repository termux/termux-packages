TERMUX_PKG_HOMEPAGE=https://dillo-browser.github.io/
TERMUX_PKG_DESCRIPTION="A small, fast graphical web browser built on FLTK"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.5"
TERMUX_PKG_SRCURL=https://github.com/dillo-browser/dillo/releases/download/v${TERMUX_PKG_VERSION}/dillo-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=db1be16c1c5842ebe07b419aa7c6ef11a45603a75df2877f99635f4f8345148b
TERMUX_PKG_DEPENDS="fltk, libiconv, libjpeg-turbo, libpng, openssl, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=${TERMUX_PREFIX}/etc
--enable-cookies
--enable-ssl
"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
	autoreconf -fi
}
