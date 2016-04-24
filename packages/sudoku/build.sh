TERMUX_PKG_HOMEPAGE=https://github.com/cinemast/sudoku/
TERMUX_PKG_DESCRIPTION="Su-Do-Ku! is a console based sudoku generator/solver"
TERMUX_PKG_VERSION=1.0.5
TERMUX_PKG_FOLDERNAME=sudoku-${TERMUX_PKG_VERSION}
TERMUX_PKG_SRCURL=https://github.com/cinemast/sudoku/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_configure() {
    cd $TERMUX_PKG_SRCDIR
    sed -i -e 's/games/bin/' Makefile
    sed -i -e 's/lcurses/lncurses/' Makefile
    sed -i -e "s%/usr/local%${TERMUX_PREFIX}%" Makefile
}