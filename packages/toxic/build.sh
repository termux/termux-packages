TERMUX_PKG_HOMEPAGE=https://github.com/JFreegman/toxic
TERMUX_PKG_DESCRIPTION="A command line client for Tox"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.14.1"
TERMUX_PKG_SRCURL=https://github.com/JFreegman/toxic/archive/v${TERMUX_PKG_VERSION}/toxic-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=232b72e2546694c668a6cb6e96ac109df3770ddd124361acce30366713880278
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="c-toxcore, libconfig, libcurl, libqrencode, ncurses, zlib"
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
