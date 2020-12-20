TERMUX_PKG_HOMEPAGE=http://duc.zevv.nl/
TERMUX_PKG_DESCRIPTION="High-performance disk usage analyzer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.4
TERMUX_PKG_REVISION=8
TERMUX_PKG_SRCURL=https://github.com/zevv/duc/releases/download/$TERMUX_PKG_VERSION/duc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f4e7483dbeca4e26b003548f9f850b84ce8859bba90da89c55a7a147636ba922
TERMUX_PKG_DEPENDS="leveldb, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-x11
--with-db-backend=leveldb
--disable-cairo"
