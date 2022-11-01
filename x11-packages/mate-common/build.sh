TERMUX_PKG_HOMEPAGE=https://mate-desktop.org/
TERMUX_PKG_DESCRIPTION="Common scripts and macros to develop with MATE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.26.0
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-common/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2cf88529e2d733f256e6737fc43f7288395437955909238e293dd9ce0a12b720
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fi
}
