TERMUX_PKG_HOMEPAGE=http://www.tads.org/frobtads.htm
TERMUX_PKG_DESCRIPTION="TADS is a free authoring system for writing your own Interactive Fiction"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://www.tads.org/frobtads/frobtads-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=88c6a987813d4be1420a1c697e99ecef4fa9dd9bc922be4acf5a3054967ee788
TERMUX_PKG_RM_AFTER_INSTALL="share/frobtads/tads3/doc share/frobtads/tads3/lib/webuires"
TERMUX_PKG_DEPENDS="ncurses, libcurl"
