TERMUX_PKG_HOMEPAGE="https://github.com/tenox7/ttyplot"
TERMUX_PKG_DESCRIPTION="A realtime plotting utility for terminal with data input from stdin"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL="https://github.com/tenox7/ttyplot/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=99ae8b5923720113d034df868104fa70f4ac1d34af449224bfda690a1811baaf
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
