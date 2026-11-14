TERMUX_PKG_HOMEPAGE=https://dasm-dillon.sourceforge.io/
TERMUX_PKG_DESCRIPTION="Macro assembler with support for several 8-bit microprocessors"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.20.18"
TERMUX_PKG_SRCURL="https://github.com/dasm-assembler/dasm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6cae2ff107c7447d601366f75a1dad86504deff7fe4c0181c145dbc83e249aaf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	cp "$TERMUX_PKG_SRCDIR"/bin/* "$TERMUX_PREFIX"/bin/
}
