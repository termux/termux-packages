TERMUX_PKG_HOMEPAGE=https://github.com/topgrade-rs/topgrade/
TERMUX_PKG_DESCRIPTION="Upgrade all the things"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@laurentlbm"
TERMUX_PKG_VERSION="10.2.0"
TERMUX_PKG_SRCURL="https://github.com/topgrade-rs/topgrade/archive/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=66f11d3a08981a883c20afd40d036a7e42d8e12f8d88e0671455a83f70b495da
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm600 -t "${TERMUX_PREFIX}"/share/man/man8 "${TERMUX_PKG_SRCDIR}"/topgrade.8
}
