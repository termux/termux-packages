TERMUX_PKG_HOMEPAGE=https://gitlab.torproject.org/tpo/core/torsocks
TERMUX_PKG_DESCRIPTION="Wrapper to safely torify applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.0"
TERMUX_PKG_SRCURL=https://gitlab.torproject.org/tpo/core/torsocks/-/archive/v${TERMUX_PKG_VERSION}/torsocks-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0fc8e18f2dc2e12f1129054f6d5acc7ecc3f0345bb57ed653fc8c6674e6ecc7e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="tor"

termux_step_pre_configure() {
	./autogen.sh
}
