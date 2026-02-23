TERMUX_PKG_HOMEPAGE=https://github.com/JFreegman/toxic
TERMUX_PKG_DESCRIPTION="A command line client for Tox"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/JFreegman/toxic/archive/refs/tags/v${TERMUX_PKG_VERSION}/toxic-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6b74c82c286f9ab3a8c8a5b4bf506ab5a4aca12620792a5273988bb795ea46ad
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="c-toxcore, libconfig, libcurl, libpng, libqrencode, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make \
		PREFIX="${TERMUX_PREFIX}" \
		CC="${CC}" \
		PKG_CONFIG="${PKG_CONFIG}" \
		USER_CFLAGS="${CFLAGS}" \
		USER_LDFLAGS="${LDFLAGS}"
}

termux_step_make_install() {
	make PREFIX="${TERMUX_PREFIX}" install
}
