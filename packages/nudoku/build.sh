TERMUX_PKG_HOMEPAGE=http://jubalh.github.io/nudoku/
TERMUX_PKG_DESCRIPTION="ncurses based sudoku game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/jubalh/nudoku/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=44d3ec1ff34a010910ac7a92f6d84e8a7a4678a966999b7be27d224609ae54e1
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -i
}
