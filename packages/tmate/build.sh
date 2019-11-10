TERMUX_PKG_HOMEPAGE=https://tmate.io
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with instant terminal sharing"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.3.1
TERMUX_PKG_SRCURL=https://github.com/tmate-io/tmate/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=21cb6029d09e3809e37b9b8f1cd96b452197b8c2e28d3551d674b8e580bf4048
TERMUX_PKG_DEPENDS="libandroid-support, libevent, libmsgpack, libssh, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"

termux_step_pre_configure() {
	CFLAGS+=" -DIOV_MAX=1024"

	./autogen.sh
}
