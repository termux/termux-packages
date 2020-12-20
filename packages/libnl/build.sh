TERMUX_PKG_HOMEPAGE=https://github.com/thom311/libnl
TERMUX_PKG_DESCRIPTION="Collection of libraries providing APIs to netlink protocol based Linux kernel interfaces"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.5.0
TERMUX_PKG_SRCURL=https://github.com/thom311/libnl/releases/download/libnl${TERMUX_PKG_VERSION//./_}/libnl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=352133ec9545da76f77e70ccb48c9d7e5324d67f6474744647a7ed382b5e05fa
TERMUX_PKG_BREAKS="libnl-dev"
TERMUX_PKG_REPLACES="libnl-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthreads --disable-cli"

termux_step_pre_configure() {
	CFLAGS+=" -Dsockaddr_storage=__kernel_sockaddr_storage"
}
