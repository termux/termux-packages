TERMUX_PKG_HOMEPAGE=http://ne.di.unimi.it/
TERMUX_PKG_DESCRIPTION="ne is a free (GPL'd) text editor based on the POSIX standard"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=http://ne.di.unimi.it/ne-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RM_AFTER_INSTALL="info/"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
    CFLAGS+=" -I${TERMUX_PREFIX}"

    sed -i -e "s%usr/local%$TERMUX_PREFIX%" makefile
    sed -i -e "s%usr/local%$TERMUX_PREFIX%" src/makefile

    make PREFIX=$TERMUX_PREFIX NE_GLOBAL_DIR=$TERMUX_PREFIX/share/ne
}