TERMUX_PKG_HOMEPAGE=https://dasm-dillon.sourceforge.io/
TERMUX_PKG_DESCRIPTION="Macro assembler with support for several 8-bit microprocessors"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=2.20.11
TERMUX_PKG_SHA256=a9330adae534aeffbfdb8b3ba838322b92e1e0bb24f24f05b0ffb0a656312f36
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/dasm-dillon/dasm-dillon/${TERMUX_PKG_VERSION}/dasm-${TERMUX_PKG_VERSION}-2014.03.04-source.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_make_install() {
  cp $TERMUX_PKG_SRCDIR/bin/* $TERMUX_PREFIX/bin/
}
