TERMUX_PKG_HOMEPAGE=https://github.com/coin-or/CoinUtils
TERMUX_PKG_DESCRIPTION="An open-source collection of classes and helper functions for COIN-OR projects"
TERMUX_PKG_LICENSE="EPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:2.11.11
TERMUX_PKG_SRCURL=https://github.com/coin-or/CoinUtils/archive/refs/tags/releases/${TERMUX_PKG_VERSION#*:}.tar.gz
TERMUX_PKG_SHA256=27da344479f38c82112d738501643dcb229e4ee96a5f87d4f406456bdc1b2cb4
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_DEPENDS="libc++"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
