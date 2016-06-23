TERMUX_PKG_HOMEPAGE=https://github.com/KittyKatt/screenFetch
TERMUX_PKG_DESCRIPTION="Bash Screenshot Information Tool"
TERMUX_PKG_VERSION=3.7.0
TERMUX_PKG_SRCURL=https://github.com/KittyKatt/screenFetch/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=screenFetch-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS=""
TERMUX_PKG_MAINTAINER="Pierre Rudloff <contact@rudloff.pro>"

termux_step_make_install () {
    install screenfetch-dev ${TERMUX_PREFIX}/bin/screenfetch
    install screenfetch.1 ${TERMUX_PREFIX}/share/man/man1/
}
