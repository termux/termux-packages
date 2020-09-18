TERMUX_PKG_HOMEPAGE=https://dasm-dillon.sourceforge.io/
TERMUX_PKG_DESCRIPTION="Macro assembler with support for several 8-bit microprocessors"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.20.14
TERMUX_PKG_SRCURL=https://github.com/dasm-assembler/dasm/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c66538ad8c413a4ea88525246ed9fef2bf9c9d2e36593acdf651e06635ad7497
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
  cp $TERMUX_PKG_SRCDIR/bin/* $TERMUX_PREFIX/bin/
}
