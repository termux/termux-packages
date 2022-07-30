TERMUX_PKG_HOMEPAGE=https://github.com/r-darwish/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION="9.0.1"
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL="https://github.com/r-darwish/topgrade/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=70a1cf2c6a4de41e4c708409842968f3cf05dd5f238efac7ca0f1c9064be670a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 -t "${TERMUX_PREFIX}"/share/man/man8 "${TERMUX_PKG_SRCDIR}"/topgrade.8
}
