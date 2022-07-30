TERMUX_PKG_HOMEPAGE="https://github.com/n-t-roff/sc"
TERMUX_PKG_DESCRIPTION="A vi-like spreadsheet calculator"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
# TERMUX_PKG_VERSION does not support underscores
_REAL_VERSION=7.16_1.1.2
TERMUX_PKG_VERSION=${_REAL_VERSION//_/-}
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/n-t-roff/sc/archive/refs/tags/$_REAL_VERSION.tar.gz
TERMUX_PKG_SHA256=1802c9d3d60dac85feb783adf967bc0d2fd7e5f592d9d1df15e4e87d83efcf14
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
# n-t-roff-sc is a maintained fork of sc and thus replaces the original
TERMUX_PKG_CONFLICTS="sc"
TERMUX_PKG_REPLACES="sc"
TERMUX_PKG_PROVIDES="sc"

termux_step_post_configure () {
	CFLAGS+=" -I$TERMUX_PREFIX/include"
}
