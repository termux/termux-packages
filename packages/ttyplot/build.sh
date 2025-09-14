TERMUX_PKG_HOMEPAGE="https://github.com/tenox7/ttyplot"
TERMUX_PKG_DESCRIPTION="A realtime plotting utility for terminal with data input from stdin"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/tenox7/ttyplot/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=d1624eea52abec5538c9b19bae00f81642c2d2886cd7755988466b74424ce9ca
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-e"

termux_step_pre_configure() {
	CPPFLAGS+=" -DNCURSES_WIDECHAR=1"
	CFLAGS+=" $CPPFLAGS"
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" ttyplot
}
