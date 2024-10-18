TERMUX_PKG_HOMEPAGE=https://goaccess.io
TERMUX_PKG_DESCRIPTION="An open source real-time web log analyzer and interactive viewer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.9.3"
TERMUX_PKG_SRCURL=https://tar.goaccess.io/goaccess-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=49f0ee49e3c4a95f5f75f6806b0406746fcbf2f9ad971cae23e2ea95d3ec7837
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-utf8
--with-openssl"
