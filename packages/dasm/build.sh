TERMUX_PKG_HOMEPAGE=https://dasm-dillon.sourceforge.io/
TERMUX_PKG_DESCRIPTION="Macro assembler with support for several 8-bit microprocessors"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.20.17"
TERMUX_PKG_SRCURL="https://github.com/dasm-assembler/dasm/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=4755532fe8c990c8616b4cfbe22c3fe5820e40476343da01e088b617bd2d1144
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	cp "$TERMUX_PKG_SRCDIR"/bin/* "$TERMUX_PREFIX"/bin/
}
