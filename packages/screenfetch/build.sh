TERMUX_PKG_HOMEPAGE=https://github.com/KittyKatt/screenFetch
TERMUX_PKG_DESCRIPTION="Bash Screenshot Information Tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_VERSION=3.9.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/KittyKatt/screenFetch/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d6df4ef7763f9761d818c878465d78ef701b71002a50d4f150f65a31cc1bea37
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAINTAINER="Pierre Rudloff @Rudloff"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    install screenfetch-dev ${TERMUX_PREFIX}/bin/screenfetch
    install screenfetch.1 ${TERMUX_PREFIX}/share/man/man1/
}
