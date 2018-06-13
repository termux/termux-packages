TERMUX_PKG_HOMEPAGE=https://github.com/thom311/libnl
TERMUX_PKG_DESCRIPTION="Collection of libraries providing APIs to netlink protocol based Linux kernel interfaces"
TERMUX_PKG_VERSION=3.4.0
TERMUX_PKG_SHA256=b7287637ae71c6db6f89e1422c995f0407ff2fe50cecd61a312b6a9b0921f5bf
TERMUX_PKG_SRCURL=https://github.com/thom311/libnl/releases/download/libnl${TERMUX_PKG_VERSION//./_}/libnl-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-pthreads --disable-cli"

termux_step_pre_configure () {
	CFLAGS+=" -Dsockaddr_storage=__kernel_sockaddr_storage"
}
