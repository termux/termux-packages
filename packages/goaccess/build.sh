TERMUX_PKG_HOMEPAGE=https://goaccess.io
TERMUX_PKG_DESCRIPTION="An open source real-time web log analyzer and interactive viewer"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10"
TERMUX_PKG_SRCURL=https://tar.goaccess.io/goaccess-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=79c22a1d6c7fc299e368b89f9b6c4d348fd36d27cba013b76429d59d19ccf56a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses, openssl"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-utf8
--with-openssl"
