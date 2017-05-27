TERMUX_PKG_HOMEPAGE="http://jubalh.github.io/nudoku/"
TERMUX_PKG_DESCRIPTION="ncurses based sudoku game"
TERMUX_PKG_VERSION=0.2.5
TERMUX_PKG_SRCURL=https://github.com/jubalh/nudoku/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=1478c339409abe8f1b857bf3e54c5edbeb43954432fb6e427e52a3ff6251cc25
TERMUX_PKG_FOLDERNAME=nudoku-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=yes
termux_step_pre_configure() {
	autoreconf -i
}
