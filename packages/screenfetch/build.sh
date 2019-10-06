TERMUX_PKG_HOMEPAGE=https://github.com/KittyKatt/screenFetch
TERMUX_PKG_DESCRIPTION="Bash Screenshot Information Tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_VERSION=3.9.0
TERMUX_PKG_SRCURL=https://github.com/KittyKatt/screenFetch/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b43c83ac0289861eb831d7672ef05c81f705f0d7222c206e5c8a5975cb216f4b
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    install screenfetch-dev ${TERMUX_PREFIX}/bin/screenfetch
    install screenfetch.1 ${TERMUX_PREFIX}/share/man/man1/
}
