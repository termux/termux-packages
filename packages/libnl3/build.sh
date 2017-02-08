TERMUX_PKG_HOMEPAGE=https://www.infradead.org/~tgr/libnl/
TERMUX_PKG_DESCRIPTION="Collection of libraries providing APIs to netlink protocol based Linux kernel interfaces"
TERMUX_PKG_VERSION=3.2.25
TERMUX_PKG_SRCURL=https://www.infradead.org/~tgr/libnl/files/libnl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthreads --disable-cli"