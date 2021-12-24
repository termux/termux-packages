TERMUX_PKG_HOMEPAGE=https://github.com/cernekee/stoken
TERMUX_PKG_DESCRIPTION="Software Token for Linux/UNIX"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.92
TERMUX_PKG_SRCURL=https://github.com/cernekee/stoken/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9b9c5e0f09ca14a54454319b64af98a02d0ae1b3eb1122c95e2130736f440cd1
TERMUX_PKG_DEPENDS="libnettle, libxml2"

termux_step_pre_configure() {
	autoreconf -fi
}
