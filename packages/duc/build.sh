TERMUX_PKG_HOMEPAGE=http://duc.zevv.nl/
TERMUX_PKG_DESCRIPTION="High-performance disk usage analyzer"
TERMUX_PKG_VERSION=1.4.3
TERMUX_PKG_SHA256=504810a1ac1939fb1a70bd25e492f91ea38bcd58ae0a962ce5d35559d7775e74
TERMUX_PKG_SRCURL=https://github.com/zevv/duc/releases/download/${TERMUX_PKG_VERSION}/duc-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="leveldb, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-x11 --with-db-backend=leveldb --disable-cairo"
TERMUX_PKG_BUILD_IN_SRC="yes"
