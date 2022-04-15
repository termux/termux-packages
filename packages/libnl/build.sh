TERMUX_PKG_HOMEPAGE=https://github.com/thom311/libnl
TERMUX_PKG_DESCRIPTION="Collection of libraries providing APIs to netlink protocol based Linux kernel interfaces"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.6.0
TERMUX_PKG_SRCURL=https://github.com/thom311/libnl/releases/download/libnl${TERMUX_PKG_VERSION//./_}/libnl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=532155fd011e5a805bd67121b87a01c757e2bb24112ac17e69cb86013b970009
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_BREAKS="libnl-dev"
TERMUX_PKG_REPLACES="libnl-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthreads --disable-cli"

termux_step_pre_configure() {
	CFLAGS+=" -Dsockaddr_storage=__kernel_sockaddr_storage"
}
