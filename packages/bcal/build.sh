TERMUX_PKG_HOMEPAGE=https://github.com/jarun/bcal
TERMUX_PKG_DESCRIPTION="Command-line utility for storage conversions and calculations"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@fervi"
TERMUX_PKG_VERSION="2.4"
TERMUX_PKG_SRCURL=https://github.com/jarun/bcal/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=141f39d866f62274b2262164baaac6202f60749862c84c2e6ed231f6d03ee8df
TERMUX_PKG_DEPENDS="bc, readline"

termux_step_pre_configure() {
	make install
}
