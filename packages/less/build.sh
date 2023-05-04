TERMUX_PKG_HOMEPAGE=https://www.greenwoodsoftware.com/less/
TERMUX_PKG_DESCRIPTION="Terminal pager program used to view the contents of a text file one screen at a time"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=633
TERMUX_PKG_SRCURL=https://www.greenwoodsoftware.com/less/less-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2f201d64b828b88af36dfe6cfdba3e0819ece2e446ebe6224813209aaefed04f
TERMUX_PKG_DEPENDS="ncurses, pcre2"
TERMUX_PKG_ESSENTIAL=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-regex=pcre2"
