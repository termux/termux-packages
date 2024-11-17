TERMUX_PKG_HOMEPAGE=https://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
# less has both the GPLv3 and its own "less license" which is a variation of a BSD 2-Clause license
TERMUX_PKG_LICENSE="GPL-3.0, custom"
TERMUX_PKG_LICENSE_FILE='COPYING, LICENSE'
TERMUX_PKG_MAINTAINER="Joshua Kahn @TomJo2000"
TERMUX_PKG_VERSION=661
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.greenwoodsoftware.com/less/less-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2b5f0167216e3ef0ffcb0c31c374e287eb035e4e223d5dae315c2783b6e738ed
TERMUX_PKG_DEPENDS="ncurses, pcre2"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-regex=pcre2"

termux_step_pre_configure() {
	autoreconf -fi
}
