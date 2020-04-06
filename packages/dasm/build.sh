TERMUX_PKG_HOMEPAGE=https://dasm-dillon.sourceforge.io/
TERMUX_PKG_DESCRIPTION="Macro assembler with support for several 8-bit microprocessors"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.20.11
TERMUX_PKG_SRCURL=https://github.com/dasm-assembler/dasm/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c69bbe192159dcf75677ca13bba65c3318dc443f2df45fccd3c060b2e092c7f5
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
  cp $TERMUX_PKG_SRCDIR/bin/* $TERMUX_PREFIX/bin/
}
