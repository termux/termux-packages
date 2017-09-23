TERMUX_PKG_HOMEPAGE=https://github.com/alexdantas/nSnake
TERMUX_PKG_DESCRIPTION="Classic snake game on the terminal; made with C++ and ncurses"
TERMUX_PKG_VERSION=3.0.0
TERMUX_PKG_SRCURL=https://github.com/alexdantas/nSnake/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2630435e8d029ca640cb8457918e60478ca3d9a5011c62bfda00e247dbfdcf2c
TERMUX_PKG_DEPENDS="ncurses" 
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install () {
       cd $TERMUX_PKG_SRCDIR
       make install --prefix=${TERMUX_PREFIX}
} 

termux_step_post_make_install () {
       mv ${TERMUX_PREFIX}/usr/local/bin/nsnake ${TERMUX_PREFIX}/bin/
       rm -rf ${TERMUX_PREFIX}/usr
} 
