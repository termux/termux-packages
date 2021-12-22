TERMUX_PKG_HOMEPAGE=https://dasm-dillon.sourceforge.io/
TERMUX_PKG_DESCRIPTION="Macro assembler with support for several 8-bit microprocessors"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.20.14.1
TERMUX_PKG_SRCURL=https://github.com/dasm-assembler/dasm/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ec71ffd10eeaa70bf7587ee0d79a92cd3f0a017c0d6d793e37d10359ceea663a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
  cp $TERMUX_PKG_SRCDIR/bin/* $TERMUX_PREFIX/bin/
}
