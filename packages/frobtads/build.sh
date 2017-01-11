TERMUX_PKG_HOMEPAGE=http://www.tads.org/frobtads.htm
TERMUX_PKG_DESCRIPTION="TADS is a free authoring system for writing your own Interactive Fiction"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://www.tads.org/frobtads/frobtads-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_RM_AFTER_INSTALL="share/frobtads/tads3/doc share/frobtads/tads3/lib/webuires"
TERMUX_PKG_DEPENDS="curl, ncurses"
