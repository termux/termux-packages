TERMUX_PKG_HOMEPAGE=https://github.com/r-darwish/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION=9.0.0
TERMUX_PKG_SRCURL="https://github.com/r-darwish/topgrade/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=71277152555cfaf1359884a5d094ba841b9b6fc679337871b87476ec5a11c168
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 -t "${TERMUX_PREFIX}"/share/man/man8 "${TERMUX_PKG_SRCDIR}"/topgrade.8
}
