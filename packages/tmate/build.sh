TERMUX_PKG_HOMEPAGE=https://tmate.io
TERMUX_PKG_DESCRIPTION="Terminal multiplexer with instant terminal sharing"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://github.com/tmate-io/tmate/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f837514edbc19180d06b27713628466e68aba91654d748d6e65bfad308f5b00a
TERMUX_PKG_DEPENDS="libandroid-support, libevent, libmsgpack, libssh, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-static"

termux_step_pre_configure() {
	CFLAGS+=" -DIOV_MAX=1024"

	./autogen.sh
}
