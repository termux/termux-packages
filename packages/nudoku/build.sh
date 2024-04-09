TERMUX_PKG_HOMEPAGE=http://jubalh.github.io/nudoku/
TERMUX_PKG_DESCRIPTION="ncurses based sudoku game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.0.0"
TERMUX_PKG_SRCURL=https://github.com/jubalh/nudoku/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=56c9f8d70ca350411dccfdc5a0e2dc39aaa83da08f87ad874f7f4b7fb64b3541
TERMUX_PKG_DEPENDS="libcairo, ncurses"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="games"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-cairo
"

termux_step_pre_configure() {
	autoreconf -i
}
