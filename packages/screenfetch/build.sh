TERMUX_PKG_HOMEPAGE=https://github.com/KittyKatt/screenFetch
TERMUX_PKG_DESCRIPTION="Bash Screenshot Information Tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.9.9"
TERMUX_PKG_SRCURL=https://github.com/KittyKatt/screenFetch/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=65ba578442a5b65c963417e18a78023a30c2c13a524e6e548809256798b9fb84
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install screenfetch-dev ${TERMUX_PREFIX}/bin/screenfetch
	install screenfetch.1 ${TERMUX_PREFIX}/share/man/man1/
}
