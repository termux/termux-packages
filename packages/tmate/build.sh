TERMUX_PKG_HOMEPAGE=https://tmate.io
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with instant terminal sharing"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/tmate-io/tmate/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=62b61eb12ab394012c861f6b48ba0bc04ac8765abca13bdde5a4d9105cb16138
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libevent, libmsgpack, libssh, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"

termux_step_pre_configure() {
	CFLAGS+=" -DIOV_MAX=1024"

	./autogen.sh
}
