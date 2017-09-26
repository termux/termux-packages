TERMUX_PKG_HOMEPAGE=https://github.com/thom311/libnl
TERMUX_PKG_DESCRIPTION="Collection of libraries providing APIs to netlink protocol based Linux kernel interfaces"
TERMUX_PKG_VERSION=3.3.0
TERMUX_PKG_VERSION_DASH=`echo $TERMUX_PKG_VERSION | sed -e 's/\./_/g'`
TERMUX_PKG_SRCURL=https://github.com/thom311/libnl/releases/download/libnl$TERMUX_PKG_VERSION_DASH/libnl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=705468b5ae4cd1eb099d2d1c476d6a3abe519bc2810becf12fb1e32de1e074e4
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthreads --disable-cli"
