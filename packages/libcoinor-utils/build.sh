TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/CoinUtils
TERMUX_PKG_DESCRIPTION="An open-source collection of classes and helper functions for COIN-OR projects"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.11.6
TERMUX_PKG_SRCURL=https://github.com/coin-or/CoinUtils/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=6ea31d5214f7eb27fa3ffb2bdad7ec96499dd2aaaeb4a7d0abd90ef852fc79ca
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
