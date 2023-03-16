TERMUX_PKG_HOMEPAGE=http://sqlmap.org/
TERMUX_PKG_DESCRIPTION="Automatic SQL injection and database takeover tool"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@bread-up"
TERMUX_PKG_VERSION=1.7
TERMUX_PKG_SRCURL=https://github.com/sqlmapproject/sqlmap/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=aa00e08007bfdb06a362a0c2798073af8e7053a97ead8ed7cca86393a94ec2e1
TERMUX_PKG_DEPENDS="python"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_GROUPS="util-linux"

termux_step_make_install() {
      mkdir -p $TERMUX_PREFIX/opt/sqlmap
      mv $TERMUX_PKG_SRCDIR/sqlmap.py $TERMUX_PKG_SRCDIR/sqlmap
      mv $TERMUX_PKG_SRCDIR/sqlmap $TERMUX_PREFIX/bin
      mv $TERMUX_PKG_SRCDIR/* $TERMUX_PREFIX/opt/sqlmap
}
