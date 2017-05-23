TERMUX_PKG_HOMEPAGE=http://ne.di.unimi.it/
TERMUX_PKG_DESCRIPTION="Easy-to-use and powerful text editor"
TERMUX_PKG_MAINTAINER="David Martínez @vaites"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/ne-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1b7e63b6f6db1671e19af05fb4230b86b4d0c25679e240d52a5c094a191dd683
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RM_AFTER_INSTALL="info/"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
    CPPFLAGS+=" -Dindex=strchr"
    CFLAGS+=" -I${TERMUX_PREFIX}"

    sed -i -e "s%usr/local%$TERMUX_PREFIX%" makefile
    sed -i -e "s%usr/local%$TERMUX_PREFIX%" src/makefile

    make PREFIX=$TERMUX_PREFIX NE_GLOBAL_DIR=$TERMUX_PREFIX/share/ne
}
