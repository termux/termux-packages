TERMUX_PKG_HOMEPAGE=https://github.com/mypaint/mypaint-brushes
TERMUX_PKG_DESCRIPTION="MyPaint brushes"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.2
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/mypaint/mypaint-brushes/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=01032550dd817bb0f8e85d83a632ed2e50bc16e0735630839e6c508f02f800ac
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	autoreconf -fi
}
