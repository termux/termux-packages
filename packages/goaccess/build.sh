TERMUX_PKG_HOMEPAGE=http://goaccess.io
TERMUX_PKG_DESCRIPTION="An open source real-time web log analyzer and interactive viewer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.5
TERMUX_PKG_SRCURL=https://tar.goaccess.io/goaccess-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=355edbf8af2c14879fa4b90c68adcde340eb4efbc443d27de4f8a03a01002df9
TERMUX_PKG_DEPENDS="ncurses, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-utf8
--with-openssl"
