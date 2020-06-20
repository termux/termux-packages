TERMUX_PKG_HOMEPAGE=https://dasm-dillon.sourceforge.io/
TERMUX_PKG_DESCRIPTION="Macro assembler with support for several 8-bit microprocessors"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.20.13
TERMUX_PKG_SRCURL=https://github.com/dasm-assembler/dasm/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=48be84858d578dd7e1ac702fb2dca713a2e0be930137cbb3d6ecbeac1944ff5c
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
  cp $TERMUX_PKG_SRCDIR/bin/* $TERMUX_PREFIX/bin/
}
