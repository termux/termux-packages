TERMUX_PKG_HOMEPAGE=http://www.tads.org/frobtads.htm
TERMUX_PKG_DESCRIPTION="TADS is a free authoring system for writing your own Interactive Fiction"
TERMUX_PKG_VERSION=1.2.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=705be5849293844f499a85280e793941b0eacb362b90d49d85ae8308e4c5b63c
TERMUX_PKG_SRCURL=https://github.com/realnc/frobtads/releases/download/$TERMUX_PKG_VERSION/frobtads-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_RM_AFTER_INSTALL="share/frobtads/tads3/doc share/frobtads/tads3/lib/webuires"
TERMUX_PKG_DEPENDS="ncurses, libcurl"
