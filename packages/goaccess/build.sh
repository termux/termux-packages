TERMUX_PKG_HOMEPAGE=http://goaccess.io
TERMUX_PKG_DESCRIPTION="An open source real-time web log analyzer and interactive viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.5
TERMUX_PKG_SRCURL=https://tar.goaccess.io/goaccess-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c4820e781f75d9446f6b1be5fc8d11c6ec94a47fa8dd523001698c589f46c1ba
TERMUX_PKG_DEPENDS="ncurses, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-utf8
--with-openssl"
