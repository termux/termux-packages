TERMUX_PKG_HOMEPAGE=http://www.tads.org/frobtads.htm
TERMUX_PKG_DESCRIPTION="TADS is a free authoring system for writing your own Interactive Fiction"
TERMUX_PKG_LICENSE="non-free"
TERMUX_PKG_VERSION=2.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/realnc/frobtads/releases/download/v$TERMUX_PKG_VERSION/frobtads-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=893bd3fd77dfdc8bfe8a96e8d7bfac693da0e4278871f10fe7faa59cc239a090
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RM_AFTER_INSTALL="share/frobtads/tads3/doc share/frobtads/tads3/lib/webuires"
TERMUX_PKG_DEPENDS="libc++, ncurses, libcurl"
TERMUX_PKG_LICENSE_FILE="doc/COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"
