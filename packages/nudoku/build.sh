TERMUX_PKG_HOMEPAGE=http://jubalh.github.io/nudoku/
TERMUX_PKG_DESCRIPTION="ncurses based sudoku game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.0.0"
TERMUX_PKG_SRCURL=https://github.com/jubalh/nudoku/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=91b41874cf5e323ca50a7e1fa15170aa3fb94591842df20ea394cce4a065ef9d
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
