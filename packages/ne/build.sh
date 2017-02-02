TERMUX_PKG_HOMEPAGE=http://ne.di.unimi.it/
TERMUX_PKG_DESCRIPTION="ne is a free (GPL'd) text editor based on the POSIX standard"
TERMUX_PKG_MAINTAINER="David Martínez @vaites"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_SRCURL=https://fossies.org/linux/misc/ne-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_CHECKTYPE=SHA256
TERMUX_PKG_CHECKSUM=1fa3ede11964e314db783c0e240a3826cbec2d02e5bcd700aa7e41a0c6f02fd9
TERMUX_PKG_DEPENDS="libandroid-support, ncurses"
TERMUX_PKG_RM_AFTER_INSTALL="info/"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make() {
    CFLAGS+=" -I${TERMUX_PREFIX}"

    sed -i -e "s%usr/local%$TERMUX_PREFIX%" makefile
    sed -i -e "s%usr/local%$TERMUX_PREFIX%" src/makefile

    make PREFIX=$TERMUX_PREFIX NE_GLOBAL_DIR=$TERMUX_PREFIX/share/ne
}
