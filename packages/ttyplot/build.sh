TERMUX_PKG_HOMEPAGE="https://github.com/tenox7/ttyplot"
TERMUX_PKG_DESCRIPTION="A realtime plotting utility for terminal with data input from stdin"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.7.6"
TERMUX_PKG_SRCURL="https://github.com/tenox7/ttyplot/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=37347a11899c5bfdb5f15fd69766fc5bdfdcb434aa82ae3e9dd10095c3266675
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CPPFLAGS+=" -DNCURSES_WIDECHAR=1"
	CFLAGS+=" $CPPFLAGS"
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" ttyplot
}
