TERMUX_PKG_HOMEPAGE=http://duc.zevv.nl/
TERMUX_PKG_DESCRIPTION="High-performance disk usage analyzer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.4.6"
TERMUX_PKG_SRCURL=https://github.com/zevv/duc/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1ae6d31394cc3fa7c44a9e4449baa405865c6c0ee447546a3cd8af6c642dda11
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="leveldb, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-x11
--with-db-backend=leveldb
--disable-cairo"

termux_step_pre_configure() {
	autoreconf -fiv
}
