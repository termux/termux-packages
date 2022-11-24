TERMUX_PKG_HOMEPAGE=https://gitlab.torproject.org/tpo/core/torsocks
TERMUX_PKG_DESCRIPTION="Wrapper to safely torify applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.4.0
TERMUX_PKG_SRCURL=https://gitlab.torproject.org/tpo/core/torsocks/-/archive/v${TERMUX_PKG_VERSION}/torsocks-v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c01b471d89eda9f3c8dcb85a448e8066692d0707f9ff8b2ac7e665a602291b87
TERMUX_PKG_DEPENDS="tor"

termux_step_pre_configure() {
	./autogen.sh
}

