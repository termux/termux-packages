TERMUX_PKG_HOMEPAGE="https://github.com/n-t-roff/sc"
TERMUX_PKG_DESCRIPTION="A vi-like spreadsheet calculator"
TERMUX_PKG_LICENSE="Public Domain"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="7.16-1.1.4"
TERMUX_PKG_SRCURL=https://github.com/n-t-roff/sc/archive/refs/tags/${TERMUX_PKG_VERSION/-/_}.tar.gz
TERMUX_PKG_SHA256=3c1fc0912241f8ed30c1b69c3301556b1ba9a9e53612bbc379710577be820cca
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_BUILD_IN_SRC=true
# n-t-roff-sc is a maintained fork of sc and thus replaces the original
TERMUX_PKG_CONFLICTS="sc"
TERMUX_PKG_REPLACES="sc"
TERMUX_PKG_PROVIDES="sc"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP="s/_/-/"

termux_step_post_configure () {
	CFLAGS+=" -I$TERMUX_PREFIX/include"
	sed -i "s|prefix=/usr/local|prefix=$TERMUX_PREFIX|g" Makefile
}
