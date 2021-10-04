TERMUX_PKG_HOMEPAGE=https://github.com/KittyKatt/screenFetch
TERMUX_PKG_DESCRIPTION="Bash Screenshot Information Tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.9.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/KittyKatt/screenFetch/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aa97dcd2a8576ae18de6c16c19744aae1573a3da7541af4b98a91930a30a3178
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    install screenfetch-dev ${TERMUX_PREFIX}/bin/screenfetch
    install screenfetch.1 ${TERMUX_PREFIX}/share/man/man1/
}
